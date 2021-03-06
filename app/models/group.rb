class Group < ActiveRecord::Base

  include GroupsHelper

  # foreign key relationships

  has_many :group_email_domains, dependent: :destroy
  has_many :statements, dependent: :destroy
  has_many :active_members, dependent: :destroy
  has_many :membership_histories, dependent: :destroy
  has_many :followers, dependent: :destroy
  has_many :pending_invitations, dependent: :destroy

  belongs_to :user

  # the profile image
  mount_uploader :profile_image, ImageUploader

  
  # before save section

  before_save :set_rules_to_defaults
  before_save :set_invitations_to_defaults
  before_save :set_invitations_required_since
  
  
  def validation_keys
    [:name, :display_name, :rules, :invitation_rules, :latitude, :longitude, :radius, :locations, :tagline]
  end

  validates :name, { presence:   { message: ValidationMessages::NAME_NOT_PRESENT.message },
                     length:     { message: ValidationMessages::NAME_TOO_LONG.message,
                                   maximum: Lengths::GROUP_NAME_MAX },
                     uniqueness: { message: ValidationMessages::NAME_TAKEN.message,
                                   case_sensitive: false },
                     format:     { message: ValidationMessages::NAME_FORMATTING.message,
                                   with: Regex::GROUP } }

  validates :display_name, { length: { message: ValidationMessages::DISPLAY_NAME_TOO_LONG.message,
                                       maximum: Lengths::GROUP_DISPLAY_NAME_MAX } }

  validates :latitude , numericality: { greater_than_or_equal_to:  -90, less_than_or_equal_to:       90, allow_nil: true }
  validates :longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to:      180, allow_nil: true }
  validates :radius,    numericality: { greater_than_or_equal_to:    1, less_than_or_equal_to: 10000000, allow_nil: true }

  validates :tagline, { length:   { message: ValidationMessages::TAGLINE_TOO_LONG.message,
                                    maximum: Lengths::TAGLINE_MAX } }

  validate  :profile_image_size

  validate :rules

  validate :invitation_rules

  validate :locations

  def activate
    update_attributes(active: true)
    user.received_invitations.create(group_id: id) if invitations != Invitations::NOT_REQUIRED
    user.follow(self)
  end

  def create_statement(user, statement_type)
    now = Time.zone.now
    Statement.new_statement(now, self, user, statement_type)
  end

  def get_count(state = nil, type = nil)
    set = Statement.where(group_id: id)
    set = set.where(state: StatementStates[state]) if !state.nil?
    set = set.where(statement_type: StatementTypes[type]) if !type.nil?
    set.count
  end

  def get_all_statements(statement_state, page, per_page, support_order: false)
    Group.get_all_statements [id], statement_state, page, per_page, support_order: support_order
  end

  def get_of_type(statement_type, state, page, per_page, order = "created_at DESC")
    statement_ids =  "SELECT id FROM statements WHERE group_id = :group_id AND statement_type = :statement_type"
    statement_ids += state.nil? ? " AND state != :new" : " AND state = :state"

    StatementTypes.table(statement_type).paginate(page: page, per_page: per_page).where("statement_id IN (#{statement_ids})",
                                                                                        group_id:       id,
                                                                                        statement_type: StatementTypes[statement_type],
                                                                                        new:            StatementStates[:new],
                                                                                        state:          StatementStates[state]).order(order)
  end

  def invitations_required?
    invitations != Invitations::NOT_REQUIRED
  end

  def membership_count
    membership_histories.select(:user_id).distinct.count
  end

  def member_since(user)
    membership_histories.where(user_id: user.id, active: true).first.created_at
  end

  def active_since(user)
    active_members.find_by(user_id: user.id).created_at
  end

  def statement_accepted(statement)
    if statement.statement_type == StatementTypes[:display_name]
      update_attributes(display_name: statement.get_content.display_name)
    elsif statement.statement_type == StatementTypes[:tagline]
      update_attributes(tagline: statement.get_content.tagline)
    elsif statement.statement_type == StatementTypes[:invitation]
      update_attributes(invitations: statement.get_content.invitations)
    elsif statement.statement_type == StatementTypes[:profile_image]
      update_attributes(profile_image: statement.get_content.image)
    elsif statement.statement_type == StatementTypes[:location]
      location = statement.get_content
      if location.change_type == LocationChangeTypes[:add]
        update_attributes(latitude:  statement.get_content.latitude,
                          longitude: statement.get_content.longitude,
                          radius:    statement.get_content.radius)
      elsif location.change_type == LocationChangeTypes[:remove_all]
        update_attributes(latitude:  nil,
                          longitude: nil,
                          radius:    nil)
      end
    elsif statement.statement_type == StatementTypes[:rule]
      rule = statement.get_content
      if rule.rule_type == RuleTypes[:lifespan]
        update_attributes(lifespan_rule: rule.rule_value)
      elsif rule.rule_type == RuleTypes[:support_needed]
        update_attributes(support_needed_rule: rule.rule_value)
      elsif rule.rule_type == RuleTypes[:votespan]
        update_attributes(votespan_rule: rule.rule_value)
      elsif rule.rule_type == RuleTypes[:votes_needed]
        update_attributes(votes_needed_rule: rule.rule_value)
      elsif rule.rule_type == RuleTypes[:yeses_needed]
        update_attributes(yeses_needed_rule: rule.rule_value)
      elsif rule.rule_type == RuleTypes[:inactivity_timeout]
        update_attributes(inactivity_timeout_rule: rule.rule_value)
      end
    elsif statement.statement_type == StatementTypes[:group_email_domain_change]
      domain_change = statement.get_content
      if domain_change.change_type == GroupEmailDomainChangeTypes[:add]
        group_email_domains.create(domain: domain_change.domain) if !group_email_domains.exists?(domain: domain_change.domain)
      elsif domain_change.change_type == GroupEmailDomainChangeTypes[:remove]
        group_email_domains.find_by(domain: domain_change.domain).destroy if group_email_domains.exists?(domain: domain_change.domain)
      elsif domain_change.change_type == GroupEmailDomainChangeTypes[:remove_all]
        group_email_domains.destroy_all
      end
    end
  end

  def email_domain_input_options
    options = []
    group_email_domains.each do |group_email_domain|
      options << [group_email_domain.domain, group_email_domain.id]
    end
    options
  end

  def send_invitation(email, send_notification = true)
    email_address = EmailAddress.find_by(email: email)
    if !email_address.nil?
      email_address.user.received_invitations.find_or_create_by(group_id: id)
      UserMailer.invited(email_address.user, self).deliver_later if send_notification && email_address.user.user_notification.when_invited
    else
      pending_invitations.find_or_create_by(email: email)
      UserMailer.invited_signup(email, self).deliver_later if send_notification
    end
  end

  def num_voting_statements
    Statement.num_voting_statements [id]
  end

  def num_voted_statements(user)
    Vote.num_voted_statements [id], user
  end

  def Group.get_all_statements(group_ids, statement_state, page, per_page, support_order: false)
    if statement_state.nil?
      @all_statements = Statement.paginate(page: page, per_page: per_page).where(group_id: group_ids).where.not(state: StatementStates[:new])
    else
      @all_statements = Statement.paginate(page: page, per_page: per_page).where(group_id: group_ids, state: StatementStates[statement_state])
    end

    if support_order
      @all_statements = @all_statements
                        .joins("LEFT OUTER JOIN (SELECT statement_id, COUNT(*) AS c FROM supports GROUP BY statement_id) AS counts ON statements.id = counts.statement_id")
                        .order("counts.c DESC, updated_at DESC")
    elsif statement_state == :voting
      @all_statements = @all_statements.order(vote_began_at: :desc)
    else
      @all_statements = @all_statements.order(created_at: :desc)
    end

    @all_statements
  end

  def create_initial_group_config(statement)
    return nil if active

    initial_group = InitialGroup.create(statement_id:            statement.id,
                                        display_name:            display_name,
                                        tagline:                 tagline,
                                        profile_image:           profile_image,
                                        lifespan_rule:           lifespan_rule,
                                        support_needed_rule:     support_needed_rule,
                                        votespan_rule:           votespan_rule,
                                        votes_needed_rule:       votes_needed_rule,
                                        yeses_needed_rule:       yeses_needed_rule,
                                        inactivity_timeout_rule: inactivity_timeout_rule,
                                        invitations:             invitations,
                                        latitude:                latitude,
                                        longitude:               longitude,
                                        radius:                  radius)
    {
      initial_group:               initial_group,
      initial_group_email_domains:
        group_email_domains.map { |group_email_domain| InitialGroupEmailDomain.create(initial_group_id:      initial_group.id,
                                                                                      group_email_domain_id: group_email_domain.id) }
    }
  end

  private

  def set_rules_to_defaults
    self.lifespan_rule           ||= RuleDefaults[:lifespan]
    self.support_needed_rule     ||= RuleDefaults[:support_needed]
    self.votespan_rule           ||= RuleDefaults[:votespan]
    self.votes_needed_rule       ||= RuleDefaults[:votes_needed]
    self.yeses_needed_rule       ||= RuleDefaults[:yeses_needed]
    self.inactivity_timeout_rule ||= RuleDefaults[:inactivity_timeout]
  end

  def set_invitations_to_defaults
    self.invitations             ||= Invitations::DEFAULT
  end

  def set_invitations_required_since
    if invitations == Invitations::NOT_REQUIRED
      self.invitations_required_since = nil
    else
      self.invitations_required_since ||= Time.zone.now
    end
  end

  def rules
    errors.add(:rules, ValidationMessages::LIFESPAN_DURATION.message) if
      lifespan_rule && (lifespan_rule < Timespans::LIFESPAN_MIN || lifespan_rule > Timespans::LIFESPAN_MAX)
    errors.add(:rules, ValidationMessages::SUPPORT_NEEDED_BOUNDS.message) if
      support_needed_rule && (support_needed_rule < Needed::SUPPORT_MIN || support_needed_rule > Needed::SUPPORT_MAX)
    errors.add(:rules, ValidationMessages::VOTESPAN_DURATION.message) if
      votespan_rule && (votespan_rule < Timespans::VOTESPAN_MIN || votespan_rule > Timespans::VOTESPAN_MAX)
    errors.add(:rules, ValidationMessages::VOTES_NEEDED_BOUNDS.message) if
      votes_needed_rule && (votes_needed_rule < Needed::VOTES_MIN || votes_needed_rule > Needed::VOTES_MAX)
    errors.add(:rules, ValidationMessages::YESES_NEEDED_BOUNDS.message) if
      yeses_needed_rule && (yeses_needed_rule < Needed::YESES_MIN || yeses_needed_rule > Needed::YESES_MAX)
    errors.add(:rules, ValidationMessages::INACTIVITY_TIMEOUT_DURATION.message) if
      inactivity_timeout_rule && (inactivity_timeout_rule < Timespans::INACTIVITY_TIMEOUT_MIN || inactivity_timeout_rule > Timespans::INACTIVITY_TIMEOUT_MAX)
  end
  
  def invitation_rules
    errors.add(:invitation_rules, ValidationMessages::INVITATIONS_BOUNDS.message) if
      invitations && (invitations != Invitations::NOT_REQUIRED && (invitations < 0 || invitations > Invitations::MAX_PER_DAY))
  end

  def locations
    errors.add(:locations, ValidationMessages::LOCATION_FIELDS.message) if
      (latitude || longitude || radius) && !(latitude && longitude && radius)
  end

  def profile_image_size
    errors.add(:image_size, ValidationMessages::IMAGE_TOO_LARGE.message) if
      profile_image && profile_image.size > Sizes::IMAGE_FILE_MAX
  end
  
end
