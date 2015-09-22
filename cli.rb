require './wunderground.rb'

ActiveRecord::Base.establish_connection(
  adapter:  'sqlite3',
  database: 'production.sqlite3'
)

emoji = {
  "chanceflurries": ❄️,
  "chancerain": 🌂,
  "chancesleet": ❄️,
  "chancesnow": ❄️,
  "chancetstorms": ⚡,
  "clear": 🌞,
  "flurries": gif ,
  "fog": 🌁,
  "hazy": 🌁,
  "mostlycloudy": ☁️,
  "mostlysunny": ⛅,
  "partlycloudy": ☁️,
  "partlysunny": ⛅,
  "rain": ☔,
  "sleet": ❄️,
  "snow": ❄️,
  "sunny": 🌞,
  "tstorms": ⚡,
  "cloudy": ☁️,
  "partlycloudy": ☁️,
  "sunrise": 🌅,
  "sunset": 🌇,
  "New Moon": 🌑,
  "Waxing Crescent Moon": 🌒,
  "First Quarter Moon": 🌓,
  "Waxing Gibbous Moon": 🌔,
  "Full Moon": 🌕,
  "Waning Gibbous Moon": 🌖,
  "Last Quarter Moon": 🌗,
  "Waning Crescent Moon": 🌘,
  "hurricane": 🌀,
}

def leave(msg, status=0)
  puts "#{msg}"
  exit status
end

HTTParty.head("http://www.google.com") rescue leave("No internet connection", 1)

