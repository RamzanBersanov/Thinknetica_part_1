require_relative 'manufacturer'
require_relative 'instance_counter'
require_relative 'train'
require_relative 'route'
require_relative 'station'
require_relative 'cargo_train'
require_relative 'passenger_train'
require_relative 'wagon'
require_relative 'cargo_wagon'
require_relative 'passenger_wagon'

class Main
  
  def initialize
    @stations = []
    @trains = {}
    @routes = {}
  end

  def go
    loop do
      puts 'Выберите действие'
      puts '1 Действие с поездами'
      puts '2 Действие со станциями'
      puts '3 Действие с  маршрутами'
      puts '4 Действия с вагонами'
      id = gets.chomp.to_i
      case id
      when 1 then trains_menu
      when 2 then stations_menu
      when 3 then routes_menu
      when 4 then wagons_menu
      else
        exit
      end
    end
  end

  private #Все возможности работы с кодом реализованы через метод "go"

  def go_to_next_station(train)
    train.go_to_next_station
  end

  def go_to_prev_station(train)
    train.go_to_prev_station
  end

  def routes_menu
    if @stations.count > 1
      loop do
        puts 'Введите желаемое действие'
        puts '1 Создать маршрут'
        puts '2 Выбрать маршрут'
        puts '3 Показать количество маршрутов'
        id = gets.chomp.to_i
        case id
        when 1 then create_route
        
        when 2 
          if @routes.any?
            route_list
            puts "Введите id маршрута"
            route = gets.chomp.to_s
            route_menu(@routes[route])
          else
            'Маршрутов нет'
          end
        when 3 then puts "Всего маршрутов: #{Route.instances}"
        else
          break
        end
      end
    else
      puts 'Для создания маршрута нужно минимум две станции'
    end
  end

  def route_list
    @routes.each do |index, value|
      puts "Маршрут #{value.name} с id #{index}"
    end
  end

  def getting_route(train)
    puts "Выбран поезд #{train}"
    puts 'Введите номер маршрута'
    route_list
    route_name = gets.chomp.to_s
    route_value = @routes[route_name]

    @trains[train.number].getting_route(route_value)
    puts "Поезд №#{train.number} готов ехать с станции #{route_value.stations.first.name} на станцию #{route_value.stations.last.name}"
  end

  def route_menu(route)
    loop do
      puts "1 Добавить станцию в маршруте #{route.name} "
      puts "2 Удалить станцию в маршруте #{route.name} "
      puts "3 Проверить валидность маршрута "
      
      act = gets.chomp.to_i
      case act
      when 1 then add_station(route)
      when 2 then remove_station(route)
      when 3 then puts valid_route?(route)
      else
        break
      end
    end
  end

  def add_station(route)
    puts 'Выберите станцию'
    stations_list
    stations_id = gets.chomp.to_i
    station = @stations[stations_id]
    raise 'Станция уже добавлена' if route.stations.include? station
    route.add_station(station)
    puts "Станция #{station.name} добавлена в маршрут #{route.name}"
  rescue RuntimeError => e
    puts e.message 
    puts "Выберите другую станцию"
    retry 
  end

  def remove_station(route)
    puts 'Выберите станцию'
    puts route.list

    stations_id = gets.chomp.to_i
    station = @stations[stations_id]
    route.delete_station(station)
    "Станция #{station.name} удалена "
  end
  
  def stations_menu
    loop do
      puts '1 Cоздать станцию'
      puts '2 Выбрать станцию'
      puts '3 Показать количество станций'
      act = gets.chomp.to_i
      case act
      when 1 then create_station
      when 2 then choose_station
      when 3 then puts "Всего станций: #{Station.instances}" 
      else
        break
      end 
    end
  end
  
  def create_station
    puts 'Введите название станции не менее трех букв'
    name = gets.chomp.to_s
    station = Station.new(name)
    @stations << station
    puts "Станция #{name} создана "
  rescue RuntimeError => e
    puts e.inspect 
    retry 
  end

  def valid_station?(station)
    station.validate!
     true 
  rescue 
    false 
  end 
  
  
  def create_route 
    puts 'Введите id станций,минимум две станции через запятую'
    stations_list
    stations_ids = gets.chomp.split(',')
    route_stations = []
    @stations.each_with_index do |value, index|
      stations_ids.each do |station_id|
        route_stations << value if index == station_id.to_i
      end
    end
    stations_ids = stations_ids.join('')
    @routes[stations_ids] = Route.new(route_stations)
    route = @routes[stations_ids]
    puts "Маршрут #{route.name} создан"
  rescue RuntimeError => e
    puts e.message 
    retry 
  end


  def valid_route?(route)
    route.validate!
     true 
  rescue 
    false 
  end 
  
  def choose_station 
    stations_list
    puts "Введите id станции"
    id = gets.chomp.to_i
    station = @stations[id]
    puts "Выбрана станция #{station}"
    station_menu(station)
  end

  def station_menu(station)
    loop do
      puts '1 Проверить валидность названия станции'
      act = gets.chomp.to_i
      case act
      when 1 then puts valid_station?(station)
      else
        break
      end 
    end
  end
    
  def stations_list
    if @stations.any?
      @stations.each_with_index do |value, index|
        puts "id = #{index}  --- #{value.name} на станции находятся поезда: #{value.trains}"
      end 
    else
      puts 'Станций нет!'
    end
  end

  def trains_menu 
    loop do
      puts '1 Создать поезд'
      puts '2 Выбрать поезд'
      puts '3 Найти поезд по номеру'
      puts '4 Показать количество всех поездов'
      puts '5 Показать количество пассажирских поездов поездов'
      puts '6 Показать количество грузовых поездов'
      case gets.chomp.to_i
      when 1 then create_train 
      when 2 then choose_train
      when 3 then find_train
      when 4 then puts puts "Всего поездов: #{Train.instances}"
      when 5 then puts puts "Всего пассажирских поездов: #{PassengerTrain.instances}"
      when 6 then puts puts "Всего грузовых поездов: #{CargoTrain.instances}"
      else
        break
      end
    end
  end

  def choose_train
    if @trains.any?
          puts 'Выберите поезд'
          trains_list
          train = gets.chomp.to_s
          train_menu(@trains[train])
        else
          puts 'Поездов нет'
        end
  end 
  
  def find_train
    puts "Введите номер поезда"
    train_id = gets.chomp.to_s
    if @trains.has_key?(train_id) == false
      puts "Такого поезда нет (nil)" 
    else 
      train = (@trains[train_id])
      puts train
    end 
  end 

  def train_menu(train)
    loop do
      puts "Выбран поезд #{train.number}"
      puts '1 Добавить вагон'
      puts '2 Удалить вагон'
      puts '3 Добавить Маршрут'
      puts '4 Вперед по маршруту'
      puts '5 Назад по маршруту'
      puts '6 Назначить название компании изготовителя'
      puts '7 Узнать название компании изготовителя'
      puts '8 Посмотреть вагоны поезда'
      puts '9 Определить валидность номера поезда'
      puts '10 Выйти в меню'
      act = gets.chomp.to_i
      case act
      when 1 then add_wagons(train)
      when 2 then remove_wagons(train)
      when 3 then getting_route(train)
      when 4 then next_station(train)
      when 5 then prev_station(train)
      when 6 then define_train_firm(train)
      when 7 then firm_name(train)
      when 8 then show_wagons(train)
      when 9 then puts valid_train?(train)
      when 10
        break
      end
    end
  end 

  def add_wagons(train) 
    puts "Ваш поезд #{train.train_type} типа"
    puts 'Выберите тип вагона'
    puts '1 - Грузовой'
    puts '2 - Пасажирский'

    wagon_type = gets.chomp.to_i
    if wagon_type == 1
      wagon = Wagon.all_wagons.keep_if { |wagon| wagon.wagon_type == :cargo }
      raise NoMemoryError, "Выберите вагон #{train.train_type} типа" if train.train_type != :cargo
      raise RuntimeError, "Вагонов грузового типа нет. Создайте вагон" if wagon.empty?
        
    elsif wagon_type == 2
      wagon = Wagon.all_wagons.keep_if { |wagon| wagon.wagon_type == :passenger } 
      raise NoMemoryError, "Выберите вагон #{train.train_type} типа" if train.train_type != :passenger
      raise RuntimeError, "Вагонов грузового типа нет. Создайте вагон" if wagon.empty?
    end 
    wagon = wagon.sample
    train.add_wagon(wagon)
    puts "Вагон #{wagon} прицеплен к поезду номер #{train.number}"
    
  rescue RuntimeError => e
    puts e.inspect  
    wagons_menu
  rescue NoMemoryError => e
    puts e.inspect  
    retry 
  end

  def remove_wagons(train)
    train.remove_wagon
    puts 'Вагон отсоединен'
  end

  def show_wagons(train)
    puts "Вагоны поезда: "
    puts train.show_wagons
  end

  def valid_train?(train)
    train.validate!
     true 
  rescue 
    false 
  end 
  
  def create_train
    loop do
      puts 'Введите номер машины: три буквы/цифры, необязательный дефис, две буквы/цифры'
      train_number = gets.chomp.to_s
      puts 'Какой поезд создать?'
      puts '1. Грузовой'
      puts '2. Пасажирский'
      puts '3. Выйти в меню'
      train_type = gets.chomp.to_i 

      case train_type
      when 1
        begin  
          create_cargo_train(train_number)
          puts "Поезд #{@trains[train_number]} под номером #{train_number} создан"
      end
        
      when 2
        begin 
          create_passenger_train(train_number)
          puts "Поезд #{@trains[train_number]} под номером #{train_number} создан"
        end
     
      when 3 
        break
      end
    end
  end

  def define_train_firm(train)
    puts "Введите название фирмы"
    firm = gets.chomp
    train.define_firm(firm)
  end 

  def firm_name(train)
    puts train.firm_name
  end 

  def create_cargo_train(train_number)
    @trains[train_number] = CargoTrain.new(train_number)
  rescue RuntimeError => e
    puts e.inspect
    create_train
  end

  def create_passenger_train(train_number)
    @trains[train_number] = PassengerTrain.new(train_number)
  rescue RuntimeError => e
    puts e.inspect
    create_train
  end

  def trains_list
    @trains.each do |name, value|
      puts "Поезд номер = #{name} Тип #{value.train_type}"
    end
  end

  def wagons_menu
    loop do
      puts 'Введите действие'
      puts '1 Создать вагон'
      puts '2 Выбрать вагон по номеру'

      id = gets.chomp.to_i
      case id
      when 1 then create_wagon
      when 2 then choose_wagon
      else
        break
      end 
      end 
    end 
  end

  def choose_wagon
    Wagon.all.each_with_index do |index, value|
      puts "Вагон #{value} номер #{index} "
    end 
    puts 'Введите номер вагона'
    id = gets.chomp.to_i
    wagon = Wagon.all[id]
    puts wagon 
    raise "Вагона с таким номером нет" if wagon.nil?
    puts "Выбран вагон #{wagon} под номером #{id}"
    wagon_menu(wagon)
  rescue RuntimeError => e
    puts e.inspect
    choose_wagon
  end 

  def create_wagon
    loop do
      puts 'Какой вагон создать?'
      puts '1 - Грузовой'
      puts '2 - Пасажирский'
      puts '3 - Выйти в меню'
      wagon_type = gets.chomp.to_i
      
      case wagon_type
      when 1
        puts 'Введите название производителя'
        firm = gets.chomp.to_s
        wagon = CargoWagon.new(firm)
        #wagon.define_firm(firm)  
        puts "Создан вагон #{wagon}"
      when 2
        puts 'Введите название производителя'
        firm = gets.chomp.to_s
        wagon = PassengerWagon.new(firm)
        #wagon.define_firm(firm)   
        puts "Создан вагон #{wagon}"
      when 3
        break
      end 
    rescue RuntimeError => e
      puts e.inspect
      retry
    end 
  end 
     

  def firm_name(wagon) 
    puts wagon.firm_name
  end 


  def valid_wagon?(wagon)
    wagon.validate!
    true
  rescue
    false
  end
  def wagon_menu(wagon)
    loop do
      puts '1 Показать производителя'
      puts '2 Проверить валидность вагона'
      act = gets.chomp.to_i
      case act
      when 1 then firm_name(wagon) 
      when 2 then puts valid_wagon?(wagon)
      else
        break
      end
    end
end


Main.new.go
