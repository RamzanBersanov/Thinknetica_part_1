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
    validate!
    @@all << self
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
end
