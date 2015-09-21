require './wunderground.rb'

ActiveRecord::Base.establish_connection(
  adapter:  'sqlite3',
  database: 'production.sqlite3'
)

emoji = {
  "chanceflurries.gif": ❄️,
  "chancerain.gif": 🌂,
  "chancesleet.gif": ❄️,
  "chancesnow.gif": ❄️,
  "chancetstorms.gif": ⚡,
  "clear.gif": 🌞,
  "flurries": gif ,
  "fog.gif": 🌁,
  "hazy.gif": 🌁,
  "mostlycloudy.gif": ☁️,
  "mostlysunny.gif": ⛅,
  "partlycloudy.gif": ☁️,
  "partlysunny.gif": ⛅,
  "rain.gif": ☔,
  "sleet.gif": ❄️,
  "snow.gif": ❄️,
  "sunny.gif": 🌞,
  "tstorms.gif": ⚡,
  "cloudy.gif": ☁️,
  "partlycloudy.gif": ☁️,
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
}

def leave(msg, status=0)
  puts "#{msg}"
  exit status
end

HTTParty.head("http://www.google.com") rescue leave("No internet connection", 1)

