class Astronomy
  include Wunderground

  attr_reader :location
  attr_reader :response

  def initialize(location)
    @location = get_location(location)
    @response = get_response("astronomy", location: @location)
    # TODO: Load query into table for caching.
  end

  def percent_illuminated
    @response["moon_phase"]["percentIlluminated"].to_i
  end

  def age_of_moon
    @response["moon_phase"]["ageOfMoon"].to_i
  end

  def phase_of_moon
    @response["moon_phase"]["phaseofMoon"]
  end

  def hemisphere
    @response["moon_phase"]["hemisphere"]
  end

  def local_time_hour
    @response["moon_phase"]["current_time"]["hour"].to_i
  end

  def local_time_minute
    @response["moon_phase"]["current_time"]["minute"].to_i
  end

  def local_time
    readable_time(hour: self.local_time_hour, minute: self.local_time_minute, military_time: false, utc: false)
  end

  def sunrise_time
    readable_time(hour: self.sunrise_hour, minute: self.sunrise_minute, military_time: false, utc: false)
  end

  def sunrise_hour
    @response["moon_phase"]["sunrise"]["hour"].to_i
  end

  def sunrise_minute
    @response["moon_phase"]["sunrise"]["minute"].to_i
  end

  def sunset_time
    readable_time(hour: self.sunset_hour, minute: self.sunset_minute, military_time: false, utc: false)
  end

  def sunset_hour
    @response["moon_phase"]["sunset"]["hour"].to_i
  end

  def sunset_minute
    @response["moon_phase"]["sunset"]["minute"].to_i
  end

end
