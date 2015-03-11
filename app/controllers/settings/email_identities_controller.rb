module Settings
  class EmailIdentitiesController < ApplicationController
    before_action :get_user,       only: [:index, :create]
    before_action :user_logged_in, only: [:index, :create]
    before_action :same_user,      only: [:create]
    
    def index
      # user is assigned in the get_user before action

      # nothing else to do
    end

    def create
      # user is assigned in the get_user before action

      # user is matched in the same_user before action

      email_address = @user.email_addresses.create(email: params[:new_identity][:email])
      if email_address.valid?
        UserMailer.email_address_activation(@user, email_address).deliver_now
        flash[:info] = "Please check your email to activate this address"
      else
        PageErrors.add_errors email_address.errors.full_messages
      end
      redirect_to settings_email_identities_path
    end

    private

    def get_user
      @user = current_user
    end
    
    def user_logged_in
      unless !current_user.nil?
        flash[:danger] = "Please log in to access this page"
        redirect_to root_url
      end
    end

    def same_user
      unless @user.id == params[:user_id].to_i
        flash[:danger] = "Something went wrong:" + @user.id.to_s + " != " + params[:user_id].to_s
        redirect_to root_url
      end
    end
  end
end
