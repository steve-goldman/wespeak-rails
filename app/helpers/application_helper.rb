module ApplicationHelper
  def full_title(page_title = '')
    base_title = "WeSpeak"
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end

  def digest(string)
    cost = ActiveModel::SecurePassword.min_cost ?
             BCrypt::Engine::MIN_COST :
             BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def new_token
    SecureRandom.urlsafe_base64
  end

end
