class Train
    NUMBER = /\A\w{3}-*\w{2}\Z/
    include InstanceCounter
    include Manufacturer
    attr_reader :number, :type
    attr_accessor :train_type, :wagons, :current_station, :current_speed, :route
  
    def initialize(number)
      @number = number
      @type = type
      @wagons = []
      @current_speed = 0
      register_instance()
    end

    def validate!
      raise "Введен неверный номер" if number !~ NUMBER
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
      if wagon.wagon_type == train_type
        wagons << wagon
      else
      end
    end

    def show_wagons
      self.wagons
    end 
  
    def getting_route(route)
      @route = route
      route.stations.first.add_train(self)
      @current_station = route.stations.first
    end
  
    def go_to_prev_station
      if @current_station != @route.stations.first
        @current_station.send_train(self)
        @current_station = prev_station
        @current_station.add_train(self)
        @current_station
      end
    end
  
    def go_to_next_station
      if @current_station != @route.stations.last
        @current_station.send_train(self)
        @current_station = next_station
        @current_station.add_train(self)
        @current_station
      end
    end
  
    def next_station
      return if current_station_index == @route.stations.count - 1
  
      @route.stations[current_station_index + 1]
    end
  
    def prev_station
      return if current_station_index.zero?
  
      @route.stations[current_station_index - 1]
    end
  
    protected
  
    def current_station_index
      @route.stations.index(@current_station)
    end
  end
