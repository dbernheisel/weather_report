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
sample_current_conditions_response = $all_responses["current_conditions_response"]
sample_current_hurricanes_response = $all_responses["current_hurricanes_response"]
sample_daily_forecast_response = $all_responses["daily_forecast_response"]
sample_daily_10day_forecast_response = $all_responses["daily_10day_forecast_response"]
sample_hourly_forecast_response = $all_responses["hourly_forecast_response"]
sample_hourly_10day_forecast_response = $all_responses["hourly_10day_forecast_response"]

class Astronomy
  def initialize(location)
    @location = Wunderground.get_location(location)
    @response = $all_responses["astronomy_response"]
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

  def test_hourly
    a = Astronomy.new("Australia/Sydney")
    assert_equal "First Quarter", a.phase_of_moon
    assert_equal "5:27am", a.local_time
    assert_equal "5:45am", a.sunrise_time
    assert_equal "5:51pm", a.sunset_time
  end
end
