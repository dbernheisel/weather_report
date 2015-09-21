require 'active_record'
require './forecast'
require './hourly'
require './daily'
require './alert'
require './hurricane'
require './astronomy'
require './condition'
require 'httparty'
require 'json'

# http://www.wunderground.com/weather/api

ActiveRecord::Base.establish_connection(
  adapter:  'sqlite3',
  database: 'development.sqlite3'
)

module Wunderground
  @api_key = ENV['WUNDERGROUND_API']

  def get_location(location)
    # TODO: Parse supplied location
    return location
  end

  private
  def get_response(endpoint)
    HTTParty.get("http://api.wunderground.com/api/#{Wunderground.api_key}/#{endpoint}/q/#{Wunderground.get_location(@location)}.json")
  end
end
