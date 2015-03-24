class Group < ActiveRecord::Base

  include GroupsHelper

  # foreign key relationships

  has_many :group_email_domains, dependent: :destroy
  has_many :statements
  has_many :active_members

  # after initialize section

  after_initialize :set_rules_to_defaults
  after_initialize :set_invitations_to_defaults
  
  def validation_keys
    [:name, :rules, :invitation_rules]
  end

  validates :name, { presence:   { message: ValidationMessages::NAME_NOT_PRESENT.message },
                     length:     { message: ValidationMessages::NAME_TOO_LONG.message,
                                   maximum: Lengths::GROUP_NAME_MAX },
                     uniqueness: { message: ValidationMessages::NAME_TAKEN.message,
                                   case_sensitive: false },
                     format:     { message: ValidationMessages::NAME_FORMATTING.message,
                                   with: Regex::GROUP } }

  validate :rules

  validate :invitation_rules

  def activate
    update_attributes(active:                          true,
                      initial_lifespan_rule:           lifespan_rule,
                      initial_support_needed_rule:     support_needed_rule,
                      initial_votespan_rule:           votespan_rule,
                      initial_votes_needed_rule:       votes_needed_rule,
                      initial_yeses_needed_rule:       yeses_needed_rule,
                      initial_inactivity_timeout_rule: inactivity_timeout_rule,
                      initial_invitations:             invitations)
  end

  def create_statement(user, statement_type)
    statements.create(user_id:        user_id,
                      statement_type: statement_type,
                      state:          StatementStates[:alive],
                      lifespan:       lifespan_rule)
  end

  def get_all_statements(state)
    if state.nil?
      @statements_array = Statement.where(group_id: id).map { |record| record }
    else
      @statements_array = Statement.where(group_id: id, state: StatementStates[state]).map { |record| record }
    end

    ids_filter  = "SELECT statement_id FROM statements WHERE group_id = :group_id"
    ids_filter += " AND state = :state" if !state.nil?

    @statement_pointers = []

    [
      [Tagline, :tagline],
      [Update,  :update ],
    ].each do |tuple|
      insert_filtered(tuple[0].where("statement_id IN (#{ids_filter})", group_id: id, state: StatementStates[state]),
                      tuple[1])
    end

    @statement_pointers
  end

  def get_of_type(statement_type, state)
    # TODO: where can i move this that makes sense?
    type_map = {
      tagline: Tagline,
      update:  Update,
    }
  
    statement_ids =  "SELECT statement_id FROM statements WHERE group_id = :group_id AND statement_type = :statement_type"
    statement_ids += " AND state = :state" if !state.nil?

    type_map[statement_type].where("statement_id IN (#{statement_ids})",
                                   group_id:       id,
                                   statement_type: StatementTypes[statement_type],
                                   state:          StatementStates[state])
  end

  private

  # for shoving the records from a specific table into the proper location
  # of the pointers array
  def insert_filtered(records, content_type)
    last_i = -1
    records.each do |record|
      for i in (last_i + 1)..(@statements_array.count - 1)
        @statement_pointers[i] = { statement_type: content_type, content: record } and last_i = i and break if
          @statements_array[i].statement_type == StatementTypes[content_type]
      end
    end
  end

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

end
