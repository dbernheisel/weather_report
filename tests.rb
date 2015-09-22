require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require './wunderground'
require './migration'

ActiveRecord::Base.establish_connection(
  adapter:  'sqlite3',
  database: 'test.sqlite3'
)
ActiveRecord::Migration.verbose = false
ActiveSupport::TestCase.test_order = :random

WundergroundMigration.migrate(:down) rescue false
WundergroundMigration.migrate(:up) rescue false

# Load API samples
$all_responses = JSON.parse(File.read('tests.json'))
sample_current_alerts_response = $all_responses["current_alerts_response"]
sample_current_hurricanes_response = $all_responses["current_hurricanes_response"]
sample_hourly_forecast_response = $all_responses["hourly_forecast_response"]
sample_hourly_10day_forecast_response = $all_responses["hourly_10day_forecast_response"]

class Astronomy
  def initialize(location)
    @location = get_location(location)
    @response = $all_responses["astronomy_response"]
  end
end
class Condition
  def initialize(location)
    @location = get_location(location)
    response = $all_responses["current_conditions_response"]
    @response = response["current_observation"]
    self.from_json(@response.to_json)
  end
end
class DailyForecast
  def initialize(location, ten_day: false)
    @location = get_location(location)
    response = $all_responses["daily_forecast_response"]
    response = $all_responses["daily_10day_forecast_response"] if ten_day
    @response = response["forecast"]["simpleforecast"]
    get_forecasts(ten_day: ten_day)
  end
end

class WundergroundTests < ActiveSupport::TestCase
  def test_astronomy
    a = Astronomy.new("Australia/Sydney")
    assert_equal "First Quarter", a.phase_of_moon
    assert_equal "5:27am", a.local_time
    assert_equal "5:45am", a.sunrise_time
    assert_equal "5:51pm", a.sunset_time
    assert_equal 55, a.percent_illuminated
    assert_equal 8, a.age_of_moon
    assert_equal "South", a.hemisphere
  end

  def test_conditions
    a = Condition.new("CA/San_Francisco")
    assert_equal "KCASANFR58", a.station_id
    assert_equal "San Francisco, CA", a.display_location["full"]
    assert_equal "SOMA - Near Van Ness, San Francisco, California", a.observation_location["full"]
    assert_equal "7:26pm", a.local_time
    assert_equal "7:23pm", a.observation_time
  end

  def test_daily_forecast
    ten = DailyForecast.new("CA/San_Francisco", ten_day: true)
    four = DailyForecast.new("CA/San_Francisco")
    assert_equal "79°F", four.forecasts[3][:high]
    assert_equal "58°F", four.forecasts[3][:low]
    assert_equal "13/mph NNW", ten.forecasts[9][:average_windspeed]
  end

  def test_alerts
    a = Alert.new("NM/Glenwood")
    assert_equal "Flash Flood Watch", a.alerts[0][:description]
    assert_equal "9:36pm", a.alerts[0][:starts_at]
    assert_equal "12:00am", a.alerts[0][:expires_at]
    assert_equal 5, a.alerts[0][:zones].length
  end

  def test_hurricanes

  end
end
