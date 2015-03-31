module Settings
  class EmailIdentitiesController < ApplicationController

    include EmailIdentitiesHelper
    
    include ActionView::Helpers::DateHelper
    
    before_action :logged_in,         only: [:index, :create, :destroy, :edit]
    before_action :email_creates,     only: [:create]
    before_action :email_present,     only: [:destroy, :edit]
    before_action :email_not_primary, only: [:destroy, :edit]
    before_action :email_activated,   only: [:edit]
    
    def index
    end

    def create
      UserMailer.email_address_activation(@user, @email_address).deliver_now
      redirect_with_flash(FlashMessages::EMAIL_SENT, settings_email_identities_path)
    end

    def destroy
      @email_address.destroy
      redirect_to settings_email_identities_path
    end

    def edit
      @user.update_attribute(:primary_email_address_id, @email_address.id)
      redirect_to settings_email_identities_path
    end

    private

    def logged_in
      @user = current_user
      redirect_with_flash(FlashMessages::NOT_LOGGED_IN, root_url) if @user.nil?
    end

    def email_present
      @email_address = EmailAddress.find_by(id: params[:id])
      redirect_with_flash(FlashMessages::EMAIL_UNKNOWN, settings_email_identities_path) if
        @email_address.nil? || @email_address.user_id != current_user.id
    end

    def email_creates
      @email_address = @user.email_addresses.create(email: params[:new_identity][:email])
      redirect_with_validation_flash(@email_address, settings_email_identities_path) if !@email_address.valid?
    end

    def email_not_primary
      redirect_with_flash(FlashMessages::CANNOT_DO_TO_PRIMARY, settings_email_identities_path) if
        @email_address.id == @user.primary_email_address_id
    end

    def email_activated
      redirect_with_flash(FlashMessages::EMAIL_NOT_ACTIVATED, settings_email_identities_path) if
        !@email_address.activated?
    end
  end
end
