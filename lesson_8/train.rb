# frozen_string_literal: true

class Train
  NUMBER = /\A\w{3}-*\w{2}\Z/.freeze
  include InstanceCounter
  include Manufacturer
  attr_reader :number, :type
  attr_accessor :train_type, :wagons, :current_station, :current_speed, :route

  def initialize(number)
    @number = number
    @type = type
    @wagons = []
    @current_speed = 0
    validate!
    register_instance
  end

  def validate!
    raise 'Введен неверный номер' if number !~ NUMBER
  end

  def add_speed(speed)
    self.current_speed += speed
  end

  def stop
    @current_speed = 0
  end

  def remove_wagon
    wagons.delete_at(-1) unless wagons.empty?
  end

  def add_wagon(wagon)
    wagons << wagon if wagon.wagon_type == train_type
  end

  def show_wagons
    wagons
  end

  def getting_route(route)
    @route = route
    route.stations.first.add_train(self)
    @current_station = route.stations.first
  end

  def go_to_prev_station
    return unless @current_station != @route.stations.first

    @current_station.send_train(self)
    @current_station = prev_station
    @current_station.add_train(self)
    @current_station
  end

  def go_to_next_station
    return unless @current_station != @route.stations.last

    @current_station.send_train(self)
    @current_station = next_station
    @current_station.add_train(self)
    @current_station
  end

  def next_station
    return if current_station_index == @route.stations.count - 1

    @route.stations[current_station_index + 1]
  end

  def prev_station
    return if current_station_index.zero?

    @route.stations[current_station_index - 1]
  end

  def wagons_info
    wagons.each_with_index do |wagon, index|
      case wagon.wagon_type
      when :cargo
        puts "Номер вагона: #{index}, тип - грузовой, доступный объем - #{wagon.free_space},"\
        "занятый объем - #{wagon.taken_space}"
      when :passenger
        puts "Номер вагона: #{index}, тип - пассажирский, свободные места - #{wagon.free_seats},"\
        "занятые места - #{wagon.taken_seats}"
      end
    end
  end

  protected

  def current_station_index
    @route.stations.index(@current_station)
  end
end
