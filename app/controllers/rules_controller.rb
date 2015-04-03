class RulesController < GroupPagesControllerBase

  before_action :enforce_change_eligible, only: [:create_lifespan_rule,
                                                 :create_support_needed_rule,
                                                 :create_votespan_rule,
                                                 :create_votes_needed_rule,
                                                 :create_yeses_needed_rule,
                                                 :create_inactivity_timeout_rule]

  before_action only: [:create_lifespan_rule,
                       :create_support_needed_rule,
                       :create_votespan_rule,
                       :create_votes_needed_rule,
                       :create_yeses_needed_rule,
                       :create_inactivity_timeout_rule] do
    statement_creates :rule
  end

  before_action only: [:create_lifespan_rule] do
    rule_creates(:lifespan, params[:lifespan_rule][:rule_value])
  end

  before_action only: [:create_support_needed_rule] do
    rule_creates(:support_needed, params[:support_needed_rule][:rule_value])
  end

  before_action only: [:create_votespan_rule] do
    rule_creates(:votespan, params[:votespan_rule][:rule_value])
  end

  before_action only: [:create_votes_needed_rule] do
    rule_creates(:votes_needed, params[:votes_needed_rule][:rule_value])
  end

  before_action only: [:create_yeses_needed_rule] do
    rule_creates(:yeses_needed, params[:yeses_needed_rule][:rule_value])
  end

  before_action only: [:create_inactivity_timeout_rule] do
    rule_creates(:inactivity_timeout, params[:inactivity_timeout_rule][:rule_value])
  end

  before_action do
    get_of_type(:rule, (params[:state] || :alive.to_s).to_sym)
  end

  def create_lifespan_rule
    create
  end

  def create_support_needed_rule
    create
  end

  def create_votespan_rule
    create
  end

  def create_votes_needed_rule
    create
  end

  def create_yeses_needed_rule
    create
  end

  def create_inactivity_timeout_rule
    create
  end

  def create
    @info.set_state_alive

    respond_to do |format|
      format.html { redirect_to rules_path(@info.group.name, :alive) }
      format.js   { render 'group_pages/show_tabs' }
    end
  end

  def index
    respond_to do |format|
      format.html { @statement_tab = :rules and render 'group_pages/index' }
      format.js { render 'group_pages/show_tabs' if params[:page].nil? }
    end
  end

  private

  def rule_creates(rule_type, rule_value)
    rule = Rule.create(statement_id: @statement.id, rule_type: RuleTypes[rule_type], rule_value: rule_value)
    @statement.destroy and redirect_with_validation_flash(rule, request.referer || root_url) if !rule.valid?
  end

end
