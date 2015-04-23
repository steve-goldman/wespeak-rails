if Rails.env.development?
  Recaptcha.configure do |config|
    config.public_key  = '6LdFyQUTAAAAAG6Aw6IaVW_Fkk83vYoak3barTZ5'
    config.private_key = '6LdFyQUTAAAAANS7OG2bfIQqzk88NJ0ol6IPaLUD'
    # Uncomment the following line if you are using a proxy server:
    # config.proxy = 'http://myproxy.com.au:8080'
    # Uncomment if you want to use the newer version of the API,
    # only works for versions >= 0.3.7:
    # config.api_version = 'v2'
  end
end
