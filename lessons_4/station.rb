class Station
    attr_accessor :trains, :name
  
    def initialize(name)
      @name = name
      @trains = []
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