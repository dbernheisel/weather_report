module Wunderground
  class HourlyForecast < Forecast
    attr_reader :location
    attr_reader :response

    def initialize(location)
      @location = Wunderground.get_location(location)
      @response = Wunderground.get_response("hourly10day")
    end

    def sunset_minute
      @response["astronomy"]["sunset"]["minute"]
    end

  end
end
