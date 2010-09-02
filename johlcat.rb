# The famous @johlcat script, generated as a birthday present for @johl.
# The script requires the following gems: twitter and lolspeak.
# It reads all tweets tweeted in the last hour and retweets them to
# another twitter account, but in lolspeak.
# 
# Have phun!
#
# Author: Svenja Schroeder
# github: http://github.com/svenja
# twitter: http://www.twitter.com/sv

#!/usr/bin/env ruby

require 'rubygems'
gem 'twitter'
require 'twitter'
require 'lolspeak'

# this is supposed to be an 5 minutly cronjob, feel free to change the amount of minutes!
$fiveminsago = Time.at(Time.now.to_i - 300) # 5 minutes ago

# The OAuth stuff follows...
require 'yaml'
begin 
  config = YAML.load_file("secret.yaml")
  @oauth_token = config["oauth_token"]
  @oauth_token_secret = config["oauth_token_secret"]
  @api_key = config["api_key"]
  @api_secret = config["api_secret"]
rescue
  # Fill in your data for your own bot here here
  @oauth_token = ""
  @oauth_token_secret = ""
  @api_key = ""
  @api_secret = ""
end

def prepare_access_token(oauth_token, oauth_token_secret)
  consumer = OAuth::Consumer.new(@api_key, @api_secret,
    { :site => "http://api.twitter.com",
      :scheme => :header
    })
  # now create the access token object from passed values
  token_hash = { :oauth_token => oauth_token,
                 :oauth_token_secret => oauth_token_secret
               }
  access_token = OAuth::AccessToken.from_hash(consumer, token_hash )
  return access_token
end

oauth = prepare_access_token(@oauth_token, @oauth_token_secret)
client = Twitter::Base.new(oauth)

# Back to our regular Johlcat...
# for testing purposes...
#puts "OH HAI ".concat(tweet.text.to_lolspeak.upcase.delete('@'))
begin
	client.user_timeline( :screen_name => 'retweeted_screen_name' ).reverse.each do | tweet |
		client.update("OH HAI ".concat(tweet.text.to_lolspeak.upcase.delete('@'))) if Time.parse(tweet.created_at) > $fiveminsago
	end
rescue Twitter::Unavailable, Twitter::InformTwitter, OpenSSL::SSL::SSLError, Errno::ETIMEDOUT => error
	sleep(60) # wait for 60 seconds then retry
	retry
end	

