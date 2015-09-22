class Astronomy
  include Wunderground
  attr_reader :location
  attr_reader :response

  def initialize(location)
    @location = Wunderground.get_location(location)
    @response = Wunderground.get_response("astronomy")
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
    readable_time(self.local_time_hour, self.local_time_minute, false)
  end

  def sunrise_time
    readable_time(self.sunrise_hour, self.sunrise_minute, false)
  end

  def sunrise_hour
    @response["moon_phase"]["sunrise"]["hour"].to_i
  end

  def sunrise_minute
    @response["moon_phase"]["sunrise"]["minute"].to_i
  end

  def sunset_time
    readable_time(self.sunset_hour, self.sunset_minute, false)
  end

  def sunset_hour
    @response["moon_phase"]["sunset"]["hour"].to_i
  end

  def sunset_minute
    @response["moon_phase"]["sunset"]["minute"].to_i
  end

  private
  def readable_time(hour, minute, military_time = true)
    am_pm = "am"
    the_hour = hour.to_i
    unless military_time
      if the_hour > 12
        the_hour = the_hour - 12
        am_pm = "pm"
      end
    end
    "#{the_hour}:#{minute}#{am_pm unless military_time}"
  end
end
