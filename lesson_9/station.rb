class Station
  STATION = /[a-z]{3}/.freeze
  
  include InstanceCounter
  extend Accessors
  extend Validation

  validate :name, :presence
  validate :name, :format,:STATION
  
  attr_accessor_with_history :trains, :name
  
  @@all = []
  
  def self.all_stations
    @@all
  end
  
  def initialize(name)
    self.name = name
    self.trains = []
    @@all << self
    validate! 
    register_instance
  end
  
  # def validate!
  #   raise 'Название станции не должно быть короче трёх букв' if name !~ STATION
  # end
  
  def add_train(train)
    @trains << train if train.route.stations.include?(self)
  end
  
  def send_train(train)
    @trains.delete(train)
  end
  
  def trains_list_by_type(type)
    @trains.each { |train| train if train.type == type }
  end
 
  def each_train_wagons
    raise 'На станции нет поездов' if @trains.empty?
 
    trains.each do |train|
      puts train.number
      puts train.wagons_info
    end
  end
  
  def each_station_train
    raise 'На станции нет поездов' if @trains.empty?
 
    Station.all_stations.each do |station|
      station.trains.each do |train|
        puts "Номер поезда: #{train.number}"
        puts "Тип поезда: #{train.train_type}"
        puts "Количество вагонов: #{train.wagons.count}"
      end
    end
  end
end
