class DailyForecast
  include Wunderground
  attr_reader :location
  attr_reader :response
  attr_reader :forecasts

  # TODO: Support detailed daily forecasts (Day, Night)
  #   Pull from 'txt_forecast' instead of 'simpleforecast'
  def initialize(location, ten_day: false)
    @location = get_location(location)
    endpoint = "forecast"
    endpoint = "forecast10day" if ten_day
    response = get_response(endpoint, location: @location)
    @response = response["forecast"]["simpleforecast"]
    get_forecasts(ten_day: ten_day)
    # TODO: Load query into table for caching.
  end

  def get_forecasts(ten_day: false)
    @forecasts = []
    @response["forecastday"].each do |day|

      @forecasts << {
        date: readable_time(epoch: day["date"]["epoch"].to_i, military_time: false),
        high: "#{day["high"]["fahrenheit"]}°F",
        low: "#{day["low"]["fahrenheit"]}°F",
        conditions: day["conditions"],
        icon: day["icon"],
        average_humidity: "#{day["avehumidity"]}%",
        average_windspeed: "#{day["avewind"]["mph"]}/mph #{day["avewind"]["dir"]}",
      }
    end
  end
end
