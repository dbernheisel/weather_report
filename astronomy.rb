module Wunderground
  class Astronomy
    attr_reader :location
    attr_reader :response

    def initialize(location)
      @location = Wunderground.get_location(location)
      @response = Wunderground.get_response("astronomy")
    end

    def percent_illuminated
      @response["astronomy"]["percentIlluminated"]
    end

    def age_of_moon
      @response["astronomy"]["ageOfMoon"]
    end

    def phase_of_moon
      @response["astronomy"]["phaseofMoon"]
    end

    def hemisphere
      @response["astronomy"]["hemisphere"]
    end

    def current_time_hour
      @response["astronomy"]["current_time"]["hour"]
    end

    def current_time_minute
      @response["astronomy"]["current_time"]["minute"]
    end

    def sunrise_hour
      @response["astronomy"]["sunrise"]["hour"]
    end

    def sunrise_minute
      @response["astronomy"]["sunrise"]["minute"]
    end

    def sunset_hour
      @response["astronomy"]["sunset"]["hour"]
    end

    def sunset_minute
      @response["astronomy"]["sunset"]["minute"]
    end
  end
end
