require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require './wunderground'

ActiveRecord::Base.establish_connection(
  adapter:  'sqlite3',
  database: 'test.sqlite3'
)
ActiveRecord::Migration.verbose = false
ActiveSupport::TestCase.test_order = :random

ApplicationMigration.migrate(:down)
ApplicationMigration.migrate(:up) rescue false

# Load API samples
sample_astronomy_response = nil
sample_current_alerts_response = nil
sample_current_conditions_response = nil
sample_current_hurricanes_response = nil
sample_daily_forecast_response = nil
sample_daily_10day_forecast_response = nil
sample_hourly_forecast_response = nil
sample_hourly_10day_forecast_response = nil

File.open('tests.json') do |f|
  all_responses = JSON.parse(f)
  sample_astronomy_response = all_responses["astronomy_response"]
  sample_current_alerts_response = all_responses["current_alerts_response"]
  sample_current_conditions_response = all_responses["current_conditions_response"]
  sample_current_hurricanes_response = all_responses["current_hurricanes_response"]
  sample_daily_forecast_response = all_responses["daily_forecast_response"]
  sample_daily_10day_forecast_response = all_responses["daily_10day_forecast_response"]
  sample_hourly_forecast_response = all_responses["hourly_forecast_response"]
  sample_hourly_10day_forecast_response = all_responses["hourly_10day_forecast_response"]
  all_responses = nil
end

class WundergroundTests < ActiveSupport::TestCase
  def test_astronomy

  end
end
