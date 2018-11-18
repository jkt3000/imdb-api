require 'nokogiri'
require 'rest-client'
require 'json'
require "imdb/version"
require 'imdb/list_base'
require "imdb/watchlist"
require "imdb/userlist"


module IMDB

  def self.config
    @config ||= {}
  end

  def self.configure
    yield(config)
  end

end
