require './wunderground.rb'

ActiveRecord::Base.establish_connection(
  adapter:  'sqlite3',
  database: 'production.sqlite3'
)

state_patterns = ["Alabama", "Montana", "Alaska", "Nebraska", "Arizona",
  "Nevada", "Arkansas", "New Hampshire", "California", "New Jersey", "Colorado",
  "New Mexico", "Connecticut", "New York", "Delaware", "North Carolina",
  "Florida", "North Dakota", "Georgia", "Ohio", "Hawaii", "Oklahoma", "Idaho",
  "Oregon", "Illinois", "Pennsylvania", "Indiana", "Rhode Island", "Iowa",
  "South Carolina", "Kansas", "South Dakota", "Kentucky", "Tennessee",
  "Louisiana", "Texas", "Maine", "Utah", "Maryland", "Vermont", "Massachusetts",
  "Virginia", "Michigan", "Washington", "Minnesota", "West Virginia",
  "Mississippi", "Wisconsin", "Missouri", "Wyoming", "MT", "NE", "NV", "NH",
  "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN",
  "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY", "AL", "AK", "AZ", "AR", "CA",
  "CO", "CT", "DE", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA",
  "ME", "MD", "MA", "MI", "MN", "MS", "MO"]

emoji = {
  "chanceflurries": "❄️",
  "chancerain": "🌂",
  "chancesleet": "❄️",
  "chancesnow": "❄️",
  "chancetstorms": "⚡",
  "clear": "🌞",
  "flurries": "gif ",
  "fog": "🌁",
  "hazy": "🌁",
  "mostlycloudy": "☁️",
  "overcast": "☁️",
  "mostlysunny": "⛅",
  "partlysunny": "⛅",
  "rain": "☔",
  "sleet": "❄️",
  "snow": "❄️",
  "sunny": "🌞",
  "tstorms": "⚡",
  "cloudy": "☁️",
  "partlycloudy": "☁️",
  "sunrise": "🌅",
  "sunset": "🌇",
  "new moon": "🌑",
  "waxing crescent moon": "🌒",
  "first quarter moon": "🌓",
  "waxing gibbous moon": "🌔",
  "full moon": "🌕",
  "waning gibbous moon": "🌖",
  "last quarter moon": "🌗",
  "waning crescent moon": "🌘",
  "hurricane": "🌀"
}

moon_phase_early = {
  "0.0": "new moon",
  "25.0": "waxing crescent moon",
  "50.0": "first quarter moon",
  "75.0": "waxing gibbous moon",
  "100.0": "full moon"
}

moon_phase_late = {
  "0.0": "new moon",
  "25.0": "waning crescent moon",
  "50.0": "last quarter moon",
  "75.0": "waning gibbous moon",
  "100.0": "full moon"
}

def leave(msg, status=0)
  puts "#{msg}"
  exit status
end

def intro
intro = ""
intro += "              \e[1;33m.\e[0m\n"
intro += "                        \n"
intro += "              \e[1;33m|\e[0m         \n"
intro += "     \e[1;33m.               /\e[0m        \n"
intro += "      \e[1;33m\\\e[0m       \e[1;33mI\e[0m              \n"
intro += "                  \e[1;33m/\e[0m\n"
intro += "        \e[1;33m\\\e[0m  \e[43m    \e[0m\e[0;36m_\e[0m\n"
intro += "          \e[43m    \e[0m\e[0;36m(`  ).                   _\n"
intro += " \e[1;33m-  --==\e[0m  \e[43m   \e[0m\e[0;36m(     ).\e[1;33m=--\e[0m           .\e[1;33m+\e[0m\e[0;36m(`  )`.\n"
intro += "\e[0;36m)          \e[0m\e[43m  \e[0m\e[0;36m(       '`.          :(   .    )\n"
intro += "        .\e[1;33m+\e[0m\e[0;36m (`(      .   )     .--  `.  (    ) )\n"
intro += "\e[0;36m       ((    (..__.:'-'   .=(   )   ` _`  ) )\n"
intro += "\e[0;36m`.     `(       ) )       (   .  )     (   )  ._\n"
intro += "\e[0;36m  )      ` __.:'   )     (   (   ))     `-'.:(`  )\n"
intro += "\e[0;36m)  )  ( )       --'       `- __.'         :(      ))\n"
intro += "\e[0;36m.-'  (_.'          .')                    `(    )  ))\n"
intro += " \e[0;36m                 (_  )                     ` __.:'\n"
intro += "              \e[1;37mWEATHER GETTER\e[0m              \n"
intro += "\e[1;32m--..,___.--,--'`,---..-.--+--.,,-,,..._.--..-._.---.\e[0m\n\n"
end

HTTParty.head("http://www.google.com") rescue leave("No internet connection", 1)

puts intro
print "Where about would you like to hear the weather: "
location = gets.chomp
# state = ""
# state_patterns.each do |pattern|
#   state = pattern
#   break if location.match(/<pattern>/)
# end


a = Astronomy.new(location)
c = Condition.new(location)
f = DailyForecast.new(location, ten_day: true)
alerts = Alert.new(location)
h = HurricaneList.new

bold = "\e[1;37m"
rst = "\e[0m"

if ((alerts.alerts.length > 0) rescue false)
  puts "\e[1;31m\e[5m**-- ALERTS --**#{rst}"
  alerts.alerts.each do |a|
    puts "#{bold}#{a[:description]}#{rst}"
    puts "Started on #{a[:starts_at]}"
    puts "Expires on #{a[:expires_at]}"
    puts "Affecting these areas: "
    a[:zones].each do |z|
      puts "  #{z}"
    end
  end
  puts ""
end

puts "#{bold}CONDITIONS RIGHT NOW#{rst}"
puts "  \e[1;33m#{c.weather}#{rst} #{emoji[c.icon.to_sym]} "
puts "  \e[1;33mTemp#{rst}: #{c.temperature_string} "
puts "  \e[1;33mHumidity#{rst}: #{c.relative_humidity} "
puts "  \e[1;33mWind#{rst}: #{c.wind_string} "
puts "  \e[1;33mRain#{rst}: #{c.precip_today_string} "
puts ""

puts "#{bold}SUN/MOON #{rst}"
puts "  \e[1;33mSunrise#{rst}: #{a.sunrise_time} #{emoji[:sunrise]} "
puts "  \e[1;33mSunset#{rst}: #{a.sunset_time} #{emoji[:sunset]} "
puts "  \e[1;33mMoon Phase#{rst}: #{a.phase_of_moon} "
puts ""

if f.forecasts.length > 0
  puts "#{bold}10-Day Forecast #{rst}"
  f.forecasts.each do |forecast|
    puts "  \e[1;33m#{forecast[:date]}#{rst} | High: #{forecast[:high]} | Low: #{forecast[:low]} | #{emoji[forecast[:icon].to_sym]}  #{forecast[:conditions]}"
  end
puts ""
end

if h.hurricanes.length > 0
  puts "#{bold}Hurricane Awareness #{rst}"
  h.hurricanes.each do |hurricane|
    puts " #{emoji[:hurricane]}  \e[1;33m#{hurricane[:name]}#{rst} a size #{hurricane[:category_size]} #{hurricane[:category_name]}"
    puts "     Winds of #{hurricane[:wind_speed]} with gusts up to #{hurricane[:gust_speed]}."
  end
puts ""
end





