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

screen_name = 'johlcat' # the one and original, the target account
password = '***'
# this is supposed to be an hourly cronjob, feel free to change the amount of minutes!
$onehourago = Time.at(Time.now.to_i - 3600) # 1 hour ago

httpauth = Twitter::HTTPAuth.new( screen_name, password, @options = { :ssl => true })
client = Twitter::Base.new(httpauth)

client.user_timeline( :screen_name => 'retweeted_screen_name' ).reverse.each do | tweet |
	# for testing purposes...
	#puts "OH HAI ".concat(tweet.text.to_lolspeak.upcase.delete('@'))
	client.update("OH HAI ".concat(tweet.text.to_lolspeak.upcase.delete('@'))) if Time.parse(tweet.created_at) > $onehourago
end
