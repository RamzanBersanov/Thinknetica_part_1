class Route
    include InstanceCounter
    attr_reader :stations
    attr_accessor :name
  
    def initialize(stations = [])
      if stations.size >= 2
        @stations = stations
        puts "Маршрут #{@stations.first.name} - #{@stations.last.name} создан"
      else
        puts 'Должна быть начальная и конечная станция!'
      end
      register_instance()
    end
  
    def name_route(name)
      @name = name
    end
  
    def add_station(station)
      if stations.include? station
        puts 'Станция уже добавлена'
      else
        stations.insert(-2, station)
        puts "Станция #{station.name} добавлена в маршрут #{name}"
      end
    end
  
    def delete_station(station)
      stations.delete(station)
      puts "Станция #{station.name} удалена "
    end
  
    def list
      names = []
      stations.each do |index|
        names << index.name
      end
      names
    end
  end
