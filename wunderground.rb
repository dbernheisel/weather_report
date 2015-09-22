require 'active_record'
require 'httparty'
require 'json'
require 'date'

# http://www.wunderground.com/weather/api

ActiveRecord::Base.establish_connection(
  adapter:  'sqlite3',
  database: 'development.sqlite3'
)

module Wunderground
  def api_key
    ENV['WUNDERGROUND_API']
  end

  def get_location(location)
    # TODO: Parse supplied location
    #   Need a regex and hash of states to determine if
    #   1) match is in hash, "NC" and "North Carolina"
    #   2) match is 2 letters (state)
    #   3) match is 3 letters (airport code)
    #   4) match is 5 digits (zip code)
    #   5) match contains a decimal (lat/long)
    #   6) if no match, then use "autoip"
    #   7) TODO: support international locations
    #   8) TODO: support personal weather station codes
    return location
  end

  def readable_time(epoch: nil, hour: 0, minute: 0, military_time: true)
    if epoch
      the_date = Time.at(epoch).utc.to_datetime
      hour = the_date.strftime('%k')
      minute = the_date.strftime('%M')
    end
    am_pm = "am"
    the_hour = hour
    unless military_time
      if the_hour.to_i > 12
        the_hour = the_hour.to_i - 12
        am_pm = "pm"
      end
    end
    "#{the_hour}:#{minute}#{am_pm unless military_time}"
  end

  private
  def get_response(endpoint, location: nil)
    HTTParty.get("http://api.wunderground.com/api/#{api_key}/#{endpoint}/q/#{get_location(location)}.json")
  end
end

require './daily'
require './hourly'
require './alert'
require './hurricane'
require './astronomy'
require './condition'
