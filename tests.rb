require 'minitest/autorun'
require 'minitest/pride'
require 'active_record'
require 'pry'
require './wunderground'

ActiveRecord::Base.establish_connection(
  adapter:  'sqlite3',
  database: 'test.sqlite3'
)
ActiveRecord::Migration.verbose = false
ActiveSupport::TestCase.test_order = :random

# Don't destroy testing database, or else
# tests will count against API rate limits.
# ApplicationMigration.migrate(:down)
ApplicationMigration.migrate(:up) rescue false

class WundergroundTests < ActiveSupport::TestCase


end
