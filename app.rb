require 'dotenv'
require 'sinatra'
require 'json'
require 'openssl'
require 'net/http'
require 'net/https'

Dotenv.load
API_BASE_URL = 'https://api.demo-games.net/'
GAME_ID = '55f2dc4eba36f81935000001'

require './request_session'

def default_hash
  { game_id: GAME_ID,
    balance: "123.45", locale: "en",
    currency: "EUR", player_id: "asdf",
    variant: 'hds', callback: 'http://gladecki.pl',
    rollback_callback: 'http://gladecki.pl'
  }
end

get '/' do
  res = RequestSession.new(
    secret: ENV['SECRET'],
    api_key: ENV['API_KEY'],
    nonce: Time.now.to_i,
    hash: default_hash
  ).execute

  redirect JSON.parse(res.body)["play_url"]
end
