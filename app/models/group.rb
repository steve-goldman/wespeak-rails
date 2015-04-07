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

  
  # after initialize section

  after_initialize :set_rules_to_defaults
  after_initialize :set_invitations_to_defaults


  # before save section

  before_save :set_invitations_required_since
  
  
  def validation_keys
    [:name, :rules, :invitation_rules, :latitude, :longitude, :radius, :locations]
  end

  validates :name, { presence:   { message: ValidationMessages::NAME_NOT_PRESENT.message },
                     length:     { message: ValidationMessages::NAME_TOO_LONG.message,
                                   maximum: Lengths::GROUP_NAME_MAX },
                     uniqueness: { message: ValidationMessages::NAME_TAKEN.message,
                                   case_sensitive: false },
                     format:     { message: ValidationMessages::NAME_FORMATTING.message,
                                   with: Regex::GROUP } }

  validates :latitude , numericality: { greater_than_or_equal_to:  -90, less_than_or_equal_to:    90, allow_nil: true }
  validates :longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to:   180, allow_nil: true }
  validates :radius,    numericality: { greater_than_or_equal_to:    1, less_than_or_equal_to: 10000, allow_nil: true }

  validate :rules

  validate :invitation_rules

  validate :locations

  def activate
    update_attributes(active:                          true,
                      initial_lifespan_rule:           lifespan_rule,
                      initial_support_needed_rule:     support_needed_rule,
                      initial_votespan_rule:           votespan_rule,
                      initial_votes_needed_rule:       votes_needed_rule,
                      initial_yeses_needed_rule:       yeses_needed_rule,
                      initial_inactivity_timeout_rule: inactivity_timeout_rule,
                      initial_invitations:             invitations)
    user.received_invitations.create(group_id: id) if invitations != Invitations::NOT_REQUIRED
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

  def get_all_statements(statement_state, page, per_page, order = "created_at DESC")
    if statement_state.nil?
      @all_statements = Statement.paginate(page: page, per_page: per_page).where(group_id: id).order(order)
    else
      @all_statements = Statement.paginate(page: page, per_page: per_page).where(group_id: id, state: StatementStates[statement_state]).order(order)
    end
  end

  def get_statement_pointers
    return [] if @all_statements.empty?

    statement_ids_map = {}
    i = 0
    statement_ids = ""
    @all_statements.each do |statement|
      statement_ids_map[statement.id] = i
      statement_ids += ", " if i != 0
      statement_ids += statement.id.to_s
      i += 1
    end

    statement_pointers = []

    StatementTypes.full_tables.each do |statement_type, table|
      # this shoves the content records in the appropriate location of the statement pointers array
      table.where("statement_id IN (#{statement_ids})", group_id: id).each { |record|
        statement_pointers[statement_ids_map[record.statement_id]] = { statement_type: statement_type, content: record }
      } if table
    end

    statement_pointers
  end

  def get_of_type(statement_type, state, page, per_page, order = "created_at DESC")
    statement_ids =  "SELECT id FROM statements WHERE group_id = :group_id AND statement_type = :statement_type"
    statement_ids += " AND state = :state" if !state.nil?

    StatementTypes.table(statement_type).paginate(page: page, per_page: per_page).where("statement_id IN (#{statement_ids})",
                                                                                        group_id:       id,
                                                                                        statement_type: StatementTypes[statement_type],
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
    if statement.statement_type == StatementTypes[:tagline]
      update_attributes(tagline: statement.get_content.tagline)
    elsif statement.statement_type == StatementTypes[:invitation]
      update_attributes(invitations: statement.get_content.invitations)
    elsif statement.statement_type == StatementTypes[:profile_image]
      update_attributes(profile_image: statement.get_content.image)
    elsif statement.statement_type == StatementTypes[:location]
      update_attributes(latitude:  statement.get_content.latitude,
                        longitude: statement.get_content.longitude,
                        radius:    statement.get_content.radius)
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

    # TODO:
    #   facebook
    #   locations
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
      lifespan_rule < Timespans::LIFESPAN_MIN || lifespan_rule > Timespans::LIFESPAN_MAX
    errors.add(:rules, ValidationMessages::SUPPORT_NEEDED_BOUNDS.message) if
      support_needed_rule < Needed::SUPPORT_MIN || support_needed_rule > Needed::SUPPORT_MAX
    errors.add(:rules, ValidationMessages::VOTESPAN_DURATION.message) if
      votespan_rule < Timespans::VOTESPAN_MIN || votespan_rule > Timespans::VOTESPAN_MAX
    errors.add(:rules, ValidationMessages::VOTES_NEEDED_BOUNDS.message) if
      votes_needed_rule < Needed::VOTES_MIN || votes_needed_rule > Needed::VOTES_MAX
    errors.add(:rules, ValidationMessages::YESES_NEEDED_BOUNDS.message) if
      yeses_needed_rule < Needed::YESES_MIN || yeses_needed_rule > Needed::YESES_MAX
    errors.add(:rules, ValidationMessages::INACTIVITY_TIMEOUT_DURATION.message) if
      inactivity_timeout_rule < Timespans::INACTIVITY_TIMEOUT_MIN || inactivity_timeout_rule > Timespans::INACTIVITY_TIMEOUT_MAX
  end

  def invitation_rules
    errors.add(:invitation_rules, ValidationMessages::INVITATIONS_BOUNDS.message) if
      invitations != Invitations::NOT_REQUIRED && (invitations < 0 || invitations > Invitations::MAX_PER_DAY)
  end

  def locations
    errors.add(:locations, ValidationMessages::LOCATION_FIELDS.message) if
      (latitude || longitude || radius) && !(latitude && longitude && radius)
  end
  
end
