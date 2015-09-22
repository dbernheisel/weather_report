class HourlyForecast
  include Wunderground

  def initialize(location)
    @location = get_location(location)
    @response = get_response("hourly10day")
    # TODO: Load query into table for caching.
  end

  # TODO: Complete hourly updates.

end
