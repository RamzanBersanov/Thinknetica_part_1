# frozen_string_literal: true

class Route
  attr_accessor :stations

  def initialize(first, last)
    @stations = [first, last]
  end

  def add_station(station)
    stations.insert(-2, station)
  end

  def delete_stations(station)
    stations.delete(station) unless station == station.first || station == stations.last
  end

  def view_stations
    puts @stations
  end
end
