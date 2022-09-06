# frozen_string_literal: true

class Route
  include InstanceCounter
  attr_reader :stations
  attr_accessor :name

  def initialize(stations = [])
    @stations = stations
    @name = "@#{stations.first.name} - #{@stations.last.name}"
    validate!
    register_instance
  end

  def validate!
    raise 'Должна быть начальная и конечная станция!' if stations.size < 2
  end

  def name_route(name)
    @name = name
  end

  def add_station(station)
    stations.insert(-2, station)
  end

  def delete_station(station)
    stations.delete(station)
  end

  def list
    names = []
    stations.each do |index|
      names << index.name
    end
    names
  end
end
