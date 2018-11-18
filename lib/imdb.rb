require 'nokogiri'
require 'rest-client'
require 'json'
require "imdb/version"
require "imdb/watchlist"
require "imdb/userlist"


module IMDB
  
  BASE_URL      = "https://www.imdb/com"
  LIST_URL      = BASE_URL + "/list/LISTID"
  WATCHLIST_URL = BASE_URL + "/user/USERID/watchlist"
  DATA_URL      = BASE_URL + "/title/data"

  WATCHLIST_REGEX = /IMDbReactInitialState\.push\((.*)\)/

  def self.config
    @config ||= {}
  end

  def self.configure
    yield(config)
  end

end
