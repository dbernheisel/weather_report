class Alert
  include Wunderground
  attr_reader :location
  attr_reader :response
  attr_reader :alerts

  def initialize(location)
    @location = get_location(location)
    response = get_response("alerts", location: @location)
    @response = response["alerts"]
    get_alerts
    # TODO: Load query into table for caching.
  end

  def get_alerts
    @response.each do |alert|
      zones = []
      @alerts = []
      alert["ZONES"].each do |zone|
        z = zone_map["#{zone['state']}#{zone['ZONE']}"]
        zones << "#{county_location[z['County Location'].to_sym]} #{z['County']} (#{z['Zone Name']})".strip.titleize
      end
      @alerts << {
        description: alert["description"],
        starts_at: readable_time(epoch: alert["date_epoch"].to_i, military_time: false),
        expires_at: readable_time(epoch: alert["expires_epoch"].to_i, military_time: false),
        message: alert["message"],
        zones: zones
      }
    end
  end

  def phenomena_map
  {
    AF: "Ashfall",
    AS: "Air Stagnation",
    BS: "Blowing Snow",
    BW: "Brisk Wind",
    BZ: "Blizzard",
    CF: "Coastal Flood",
    DS: "Dust Storm",
    DU: "Blowing Dust",
    EC: "Extreme Cold",
    EH: "Excessive Heat",
    EW: "Extreme Wind",
    FA: "Areal Flood",
    FF: "Flash Flood",
    FG: "Dense Fog",
    FL: "Flood",
    FR: "Frost",
    FW: "Fire Weather",
    FZ: "Freeze",
    GL: "Gale",
    HF: "Hurricane Force Wind",
    HI: "Inland Hurricane",
    HS: "Heavy Snow",
    HT: "Heat",
    HU: "Hurricane",
    HW: "High Wind",
    HY: "Hydrologic",
    HZ: "Hard Freeze",
    IP: "Sleet",
    IS: "Ice Storm",
    LB: "Lake Effect Snow and Blowing Snow",
    LE: "Lake Effect Snow",
    LO: "Low Water",
    LS: "Lakeshore Flood",
    LW: "Lake Wind",
    MA: "Marine",
    RB: "Small Craft for Rough Bar",
    SB: "Snow and Blowing Snow",
    SC: "Small Craft",
    SE: "Hazardous Seas",
    SI: "Small Craft for Winds",
    SM: "Dense Smoke",
    SN: "Snow",
    SR: "Storm",
    SU: "High Surf",
    SV: "Severe Thunderstorm",
    SW: "Small Craft for Hazardous Seas",
    TI: "Inland Tropical Storm",
    TO: "Tornado",
    TR: "Tropical Storm",
    TS: "Tsunami",
    TY: "Typhoon",
    UP: "Ice Accretion",
    WC: "Wind Chill",
    WI: "Wind",
    WS: "Winter Storm",
    WW: "Winter Weather",
    ZF: "Freezing Fog",
    ZR: "Freezing Rain"
  }
  end

  def significance_map
  {
    W: "Warning",
    F: "Forecast",
    A: "Watch",
    O: "Outlook",
    Y: "Advisory",
    N: "Synopsis",
    S: "Statement"
  }
  end

  def county_location
  {
    nn: "northern",
    ss: "southern",
    ea: "east",
    ee: "eastern",
    ww: "western",
    er: "east central upper",
    cc: "central",
    pa: "panhandle",
    eu: "eastern upper",
    ne: "north eastern",
    se: "south eastern",
    nr: "north central upper",
    nw: "north western",
    sw: "south western",
    sr: "south central upper",
    nc: "north central",
    sc: "south central",
    wu: "western upper",
    ec: "east central",
    wc: "west central",
    so: "south",
    mi: "middle",
    pd: "piedmont",
    bb: "big bend",
    up: "upstate"
  }
  end

  def zone_map
    JSON.parse(File.read('./zone_map.json'))
  end

end
