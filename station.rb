class Station
    include InstanceCounter
    attr_accessor :trains, :name

    @@all_stations = []

    def self.all_stations 
      puts "Все станции: #{@@all_stations}"
    end      
      
    def initialize(name)
      @name = name
      @trains = []
      @@all_stations << self
      register_instance()
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
