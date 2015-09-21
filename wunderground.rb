require 'active_record'

api_key = ENV['WUNDERGROUND_API']
puts api_key

ActiveRecord::Base.establish_connection(
  adapter:  'sqlite3',
  database: 'development.sqlite3'
)

require './forecast'
require './hourly'
require './daily'
require './alert'
require './hurricane'
require './astronomy'
require './condition'
