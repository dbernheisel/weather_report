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
    return location
  end

  def readable_time(epoch: nil, hour: 0, minute: 0, military_time: true)
    if epoch
      the_date = Time.at(epoch.to_i).utc.to_datetime
      hour = the_date.strftime('%k').to_i
      minute = the_date.strftime('%M').to_i
    end
    am_pm = "am"
    the_hour = hour.to_i
    unless military_time
      if the_hour > 12
        the_hour = the_hour - 12
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
