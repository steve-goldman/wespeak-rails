class ProposalsController < GroupPagesControllerBase
  before_action :group_found,        only: [:show]
  before_action :is_active_member,   only: [:show]
  before_action :email_eligible,     only: [:show]
  before_action :change_eligible,    only: [:show]

  def show
  end

end
