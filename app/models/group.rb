class Group < ActiveRecord::Base

  include MyGroupsHelper

  # foreign key relationships

  has_many :statements
  
  def validation_keys
    [:name]
  end

  validates :name, { presence:   { message: ValidationMessages::NAME_NOT_PRESENT.message },
                     length:     { message: ValidationMessages::NAME_TOO_LONG.message,
                                   maximum: Lengths::GROUP_NAME_MAX },
                     uniqueness: { message: ValidationMessages::NAME_TAKEN.message,
                                   case_sensitive: false },
                     format:     { message: ValidationMessages::NAME_FORMATTING.message,
                                   with: Regex::GROUP } }
end
