require 'yelp'

Yelp.client.configure do |config|
  config.consumer_key = ENV["CONSUMER_KEY"]
  config.consumer_secret = ENV["CONSUMER_SECRET"]
  config.token = ENV["TOKEN"]
  config.token_secret = ENV["TOKEN_SECRET"]
end
