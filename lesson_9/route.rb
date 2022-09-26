# frozen_string_literal: true

class Route
  include InstanceCounter
  extend Accessors
  attr_accessor_with_history :name, :stations 

  
  def initialize(stations = [])
    self.stations = stations
    self.name = "@#{stations.first.name} - #{@stations.last.name}"
    register_instance
  end
  
  def name_route(name)
    @name = name
  end
  
  def add_station(station)
    @stations.insert(-2, station)
  end
  
  def delete_station(station)
    @stations.delete(station)
  end
  
  def list
    names = []
    @stations.each do |index|
      names << index.name
    end
    names
  end
end
