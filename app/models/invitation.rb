class Invitation < ActiveRecord::Base

  include GroupsHelper

  include Constants
  
  belongs_to :statement

  # validations

  def validation_keys
    [:invitation_rules, :statement_id]
  end

  validate :invitation_rules

  validates :statement_id, { presence: { message: ValidationMessages::STATEMENT_ID_NOT_PRESENT.message } }

  private

  def invitation_rules
    errors.add(:invitation_rules, ValidationMessages::INVITATIONS_BOUNDS.message) if
      !invitations || (invitations != Invitations::NOT_REQUIRED && (invitations < 0 || invitations > Invitations::MAX_PER_DAY))
  end
end
