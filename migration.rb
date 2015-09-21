require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter:  'sqlite3',
  database: 'development.sqlite3'
)

class WundergroundMigration < ActiveRecord::Migration
  def change
    create_table "weather_queries" do |t|
      t.string  "endpoint"
      t.string  "location"
      t.text    "response"
      t.timestamps
    end
  end
end
