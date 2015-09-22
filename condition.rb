class Condition
  include Wunderground
  include ActiveModel::Serializers::JSON
  attr_reader :location
  attr_reader :response
  attr_accessor :estimated, :station_id, :observation_time,
    :observation_time_rfc822, :observation_epoch, :local_time_rfc822,
    :local_epoch, :local_tz_short, :local_tz_long, :local_tz_offset,
    :weather, :temperature_string, :temp_f, :temp_c, :relative_humidity,
    :wind_string, :wind_dir, :wind_degrees, :wind_mph, :wind_gust_mph,
    :wind_kph, :wind_gust_kph, :pressure_mb, :pressure_in, :pressure_trend,
    :dewpoint_string, :dewpoint_f, :dewpoint_c, :heat_index_string,
    :heat_index_f, :heat_index_c, :windchill_string, :windchill_f, :windchill_c,
    :feelslike_string, :feelslike_f, :feelslike_c, :visibility_mi,
    :visibility_km, :solarradiation, :UV, :precip_1hr_string, :precip_1hr_in,
    :precip_1hr_metric, :precip_today_string, :precip_today_in,
    :precip_today_metric, :icon, :icon_url, :forecast_url, :history_url,
    :ob_url, :nowcast, :image, :display_location, :observation_location

  def initialize(location)
    @location = get_location(location)
    response = get_response("conditions", location: @location)
    @response = response["current_observation"]
    self.from_json(@response.to_json)
    # TODO: Load query into table for caching.
  end

  def attributes=(hash)
    hash.each do |key, value|
      send("#{key}=", value)
    end
  end

  def attributes
    instance_values
  end

  def local_time
    readable_time(epoch: local_epoch.to_i, military_time: false)
  end

  def observation_time
    readable_time(epoch: observation_epoch.to_i, military_time: false)
  end

end

