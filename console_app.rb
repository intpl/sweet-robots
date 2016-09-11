require 'pry' # FIXME
require 'dotenv' 
Dotenv.load
# require 'sinatra'
require 'json'
require 'openssl'
require 'net/http'
require 'net/https'

require './request_session'

res = RequestSession.new(
  secret: ENV['SECRET'],
  api_key: ENV['API_KEY'],
  nonce: Time.now.to_i
).execute

puts "Response #{res.code} #{res.message}: #{res.body}"
