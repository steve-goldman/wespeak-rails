class UserNotification < ActiveRecord::Base
  belongs_to :user

  before_save :set_defaults

  private

  def set_defaults
    self.vote_begins_active    = true  if vote_begins_active.nil?
    self.vote_begins_following = true  if vote_begins_following.nil?
    self.vote_ends_active      = true  if vote_ends_active.nil?
    self.vote_ends_following   = true  if vote_ends_following.nil?
    self.support_receipt       = false if support_receipt.nil?
    self.vote_receipt          = false if vote_receipt.nil?
    self.my_statement_dies     = false if my_statement_dies.nil?
    self.about_to_timeout      = true  if about_to_timeout.nil?
    self.timed_out             = true  if timed_out.nil?
    self.when_invited          = true  if when_invited.nil?
    nil
  end
end
