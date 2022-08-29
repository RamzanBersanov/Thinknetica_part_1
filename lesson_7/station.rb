class Station
  STATION = /\w{3}/
  
  include InstanceCounter
  attr_accessor :trains, :name

  @@all = []

  def self.all_stations 
    @@all
  end      
      
  def initialize(name)
    @name = name
    @trains = []
    @@all << self
    validate!
    register_instance()
  end

  def validate! 
    raise "Название станции не должно быть короче трёх букв" if @name !~ STATION
  end 
  
  def add_train(train)
    @trains << train if train.route.stations.include?(self)
  end
  
  def send_train(train)
    @trains.delete(train)
  end
  
  def trains_list_by_type(type)
    @trains.each { |train| train.type == type }
  end

  def each_train_wagons 
    #А для каждого поезда на станции выводить список вагонов в формате: Номер вагона (можно назначать автоматически), тип вагона, кол-во свободных и занятых мест (для пассажирского вагона) или кол-во свободного и занятого объема (для грузовых вагонов).
    self.trains.each do |train|
      train.number
      train.wagons_list_info
    end 
  end 

  def each_train
    #метод, который принимает блок и проходит по всем поездам на станции, передавая каждый поезд в блок
    self.trains.each { |train| train }
  end 

  def each_station_train 
    #код, который перебирает последовательно все станции и для каждой станции выводит список поездов в формате: - Номер поезда, тип, кол-во вагонов
    Station.all_stations.each do |station| 
      station.trains.each do |train|  #можно ли поменять на each_train ?
        puts "Номер поезда: #{train.number}"
        puts "Тип поезда: #{train.train_type}"
        puts "Количество вагонов: #{train.wagons.count}"
      end 
    end 
  end 


  

  
end