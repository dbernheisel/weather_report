class HurricaneList
  include Wunderground
  attr_reader :response
  attr_reader :hurricanes

  def initialize
    response = get_response("currenthurricane")
    @response = response["currenthurricane"]
    get_hurricanes
    # TODO: Load query into table for caching.
  end

  def get_hurricanes
    @hurricanes = []
    @response.each do |h|
      @hurricanes << {
        name: h["stormInfo"]["stormName"],
        category_name: h["Current"]["Category"],
        category_size: h["Current"]["SaffirSimpsonCategory"].to_i,
        wind_speed: "#{h["Current"]["WindSpeed"]["Mph"]}/mph",
        gust_speed: "#{h["Current"]["WindGust"]["Mph"]}/mph",
        direction: "#{h["Current"]["Fspeed"]["Mph"]}/mph #{h["Current"]["Movement"]["Text"]}",
        pressure: "#{h["Current"]["Pressure"]["mb"]}/mb"
      }
    end
    @hurricanes
  end
end
