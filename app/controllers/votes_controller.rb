class VotesController < GroupPagesControllerBase
  before_action :group_found,        only: [:index]
  before_action :membership_info,    only: [:index]
  before_action :email_eligible,     only: [:index]
  before_action :change_eligible,    only: [:index]

  def index
  end

end
