module Wunderground
  class DailyForecast < Forecast
    include ActiveModel::Serializers::JSON



    def initialize(location)
      @location = Wunderground.get_location(location)
      @response = Wunderground.get_response("hourly10day")
      # TODO: Load query into table for caching.
    end


  end
end
