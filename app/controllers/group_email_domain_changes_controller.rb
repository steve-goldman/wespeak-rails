class GroupEmailDomainChangesController < GroupPagesControllerBase

  before_action :enforce_change_eligible, only: [:create_add_domain,
                                                 :create_rem_domain,
                                                 :create_rem_all_domains]

  before_action only: [:create_add_domain,
                       :create_rem_domain,
                       :create_rem_all_domains] do
    statement_creates :group_email_domain_change
  end

  before_action only: [:create_add_domain] do
    group_email_domain_change_creates(:add)
  end
  
  before_action only: [:create_rem_domain] do
    group_email_domain_change_creates(:remove)
  end

  before_action only: [:create_rem_all_domains] do
    group_email_domain_change_creates(:remove_all)
  end
  
  before_action do
    get_of_type(:group_email_domain_change, (params[:state] || :alive.to_s).to_sym)
  end

  def new
    render 'group_pages/new'
  end

  def create_add_domain
    create
  end

  def create_rem_domain
    create
  end

  def create_rem_all_domains
    create
  end

  def create
    @info.set_state_alive

    respond_to do |format|
      format.html { redirect_to group_email_domain_changes_path(@info.group.name, :alive) }
      format.js   { render 'group_pages/show_tabs' }
    end
  end

  def index
    respond_to do |format|
      format.html { render 'group_pages/index' }
      format.js   { render params[:page].nil? ? 'group_pages/show_tabs' : 'group_pages/show_next_page' }
    end
  end

  private

  def group_email_domain_change_creates(change_type)
    if change_type == :add
      change = GroupEmailDomainChange.create(statement_id: @statement.id,
                                             change_type:  GroupEmailDomainChangeTypes[:add],
                                             domain:       params[:add_group_email_domain][:domain])
    elsif change_type == :remove
      domain = GroupEmailDomain.find_by(id: params[:rem_group_email_domain][:domain_id])
      change = GroupEmailDomainChange.create(statement_id: @statement.id,
                                             change_type:  GroupEmailDomainChangeTypes[:remove],
                                             domain:       domain ? domain.domain : nil)
    elsif change_type == :remove_all
      change = GroupEmailDomainChange.create(statement_id: @statement.id,
                                             change_type:  GroupEmailDomainChangeTypes[:remove_all],
                                             domain:       "bogus.com")
    else
      change = GroupEmailDomainChange.new
    end
    
    @statement.destroy and redirect_with_validation_flash(change, request.referer || root_url) if !change.valid?
  end

end
