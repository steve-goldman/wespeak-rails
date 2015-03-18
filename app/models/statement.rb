class Statement < ActiveRecord::Base

  include StatementsHelper
  
  validate :valid_statement_type
  
  private

  def valid_statement_type
    errors.add(:valid_statement_type, ValidationMessages::TYPE_INVALID.message) if
      !StatementTypes.value?(statement_type)
  end
end
