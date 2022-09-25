# frozen_string_literal: true

require_relative 'manufacturer'
require_relative 'instance_counter'
require_relative 'accessors'
require_relative 'validation'
require_relative 'train'
require_relative 'route'
require_relative 'station'
require_relative 'cargo_train'
require_relative 'passenger_train'
require_relative 'wagon'
require_relative 'cargo_wagon'
require_relative 'passenger_wagon'

class Main

  extend Accessors 
  
  CLASSES = { "1" => Train, "2" => Station, "3" => Route, "4" => Wagon }
  
  def initialize
    @stations = []
    @trains = {}
    @routes = {}
    @wagons = []
  end

  def menu
    loop do
      puts 'Выберите действие'
      puts '1 Действие с поездами'
      puts '2 Действие со станциями'
      puts '3 Действие с маршрутами'
      puts '4 Действия с вагонами'
      puts '5 Просмореть массивы значений переменных'
      puts '6 Валидировать значения переменных'
      id = gets.chomp.to_i
      menu_go(id)
    end
  end

  def menu_go(id)
    case id
    when 1 then trains_menu
    when 2 then stations_menu
    when 3 then routes_menu
    when 4 then wagons_menu
    when 5 then values_arrays_menu
    when 6 then validate_values
    else
      exit
    end
  end

  private

  def trains_menu
    loop do
      puts '1 Создать поезд'
      puts '2 Выбрать поезд'
      puts '3 Найти поезд по номеру'
      puts '4 Информация о количестве поездов'
      trains_menu_go
    end
  end

  def trains_menu_go
    case gets.chomp.to_i
    when 1 then create_train
    when 2 then choose_train
    when 3 then find_train
    when 4 then trains_number
    else
      menu
    end
  end

  def create_train
    loop do
      puts 'Введите номер машины: три буквы/цифры, необязательный дефис, две буквы/цифры'
      train_number = gets.chomp.to_s
      puts 'Какой поезд создать?'
      puts '1. Грузовой'
      puts '2. Пасажирский'
      puts '3. Выйти в меню'
      create_train_go(train_number)
    end
  end

  def create_train_go(train_number)
    case gets.chomp.to_i
    when 1 then create_cargo_train(train_number)
    when 2 then create_passenger_train(train_number)
    when 3 then trains_menu
    end
  end

  def create_cargo_train(train_number)
    @trains[train_number] = CargoTrain.new(train_number)
    puts "Поезд #{@trains[train_number]} под номером #{train_number} создан"
  rescue RuntimeError => e
    puts e.inspect
    create_train
  end

  def create_passenger_train(train_number)
    @trains[train_number] = PassengerTrain.new(train_number)
    puts "Поезд #{@trains[train_number]} под номером #{train_number} создан"
  rescue RuntimeError => e
    puts e.inspect
    create_train
  end

  def choose_train
    puts 'Поездов нет' if @trains.nil?
    puts 'Выберите поезд'
    trains_list
    train = gets.chomp.to_s
    raise 'Поезда с таким номером нет' unless @trains[train]

    train_menu(@trains[train])
  rescue RuntimeError => e
    puts e.inspect
    trains_menu
  end

  def trains_list
    @trains.each do |name, value|
      puts "Поезд номер = #{name} Тип #{value.train_type}"
    end
  end

  def train_menu(train)
    loop do
      puts "Выбран поезд #{train.number}. Выберите действие:"
      puts '1 Действия с вагонами'
      puts '2 Действия с маршрутами'
      puts '3 Информация об изготовителе'
      puts '4 Определить валидность номера поезда'
      puts '5 Выйти в меню'
      train_menu_go(train)
    end
  end

  def train_menu_go(train)
    case gets.chomp.to_i
    when 1 then train_wagons(train)
    when 2 then train_routes(train)
    when 3 then train_firm(train)
    when 4 then puts valid_train?(train)
    when 5 then menu
    else
      trains_menu
    end
  end

  def train_wagons(train)
    puts "Выбран поезд #{train.number}"
    puts '1 Добавить вагон'
    puts '2 Удалить вагон'
    puts '3 Вывести список вагонов поезда'
    puts '4 Вывести информацию о вагонах поезда'
    puts '5 Вернуться в меню'
    train_wagons_go(train)
  end

  def train_wagons_go(train)
    case gets.chomp.to_i
    when 1 then add_wagons(train)
    when 2 then remove_wagons(train)
    when 3 then show_wagons(train)
    when 4 then wagons_info(train)
    when 5 then trains_menu
    end
  end

  def train_routes(train)
    puts '1 Добавить Маршрут'
    puts '2 Вперед по маршруту'
    puts '3 Назад по маршруту'
    puts '4 Выйти в меню'
    train_routes_go(train)
  end

  def train_routes_go(train)
    case gets.chomp.to_i
    when 1 then getting_route(train)
    when 2 then go_to_next_station(train)
    when 3 then go_to_prev_station(train)
    end
  end

  def train_firm(train)
    puts '1 Назначить название компании изготовителя'
    puts '2 Узнать название компании изготовителя'
    puts '3 Выйти в меню'
    train_firm_go(train)
  end

  def train_firm_go(train)
    case gets.chomp.to_i
    when 1 then define_train_firm(train)
    when 2 then train_firm_name(train)
    end
  end

  def valid_train?(train)
    train.valid?
  #   true
  # rescue StandardError
  #   false
  end

  def define_train_firm(train)
    puts 'Введите название фирмы'
    firm = gets.chomp
    train.firm(firm)
  end

  def train_firm_name(train)
    puts train.firm_name
  end

  def getting_route(train)
    puts "Выбран поезд #{train}. Введите номер маршрута"
    route_list
    route_name = gets.chomp.to_s
    route_value = @routes[route_name]
    @trains[train.number].getting_route(route_value)
    puts "Поезд №#{train.number} имеет маршрут #{route_value.stations.first.name} - #{route_value.stations.last.name}"
  end

  def go_to_next_station(train)
    train.go_to_next_station
  end

  def go_to_prev_station(train)
    train.go_to_prev_station
  end

  def routes_menu
    puts 'Для создания маршрута нужно минимум две станции' unless @stations.count > 1
    puts 'Выберите действие:'
    puts '1 Создать маршрут'
    puts '2 Выбрать маршрут'
    puts '3 Показать количество маршрутов'
    puts '4 Выйти в меню'
    routes_menu_go
  end

  def routes_menu_go
    case gets.chomp.to_i
    when 1 then choose_route_stations
    when 2 then choose_route
    when 3 then puts "Всего маршрутов: #{Route.instances}"
    when 4 then menu

    end
  end

  def choose_route
    raise 'Маршрутов нет' unless @routes.any?

    route_list
    puts 'Введите id маршрута'
    route = gets.chomp.to_s
    route_menu(@routes[route])
  rescue RuntimeError => e
    puts e.inspect
    routes_menu
  end

  def route_list
    @routes.each do |index, value|
      puts "Маршрут #{value.name} с id #{index}"
    end
  end

  def route_menu(route)
    loop do
      puts "1 Добавить станцию в маршруте #{route.name} "
      puts "2 Удалить станцию в маршруте #{route.name} "
      puts '3 Выйти в меню'
      act = gets.chomp.to_i
      route_menu_go(act, route)
    end
  end

  def route_menu_go(act, route)
    case act
    when 1 then add_station(route)
    when 2 then remove_station(route)
    when 3 then routes_menu
    end
  end

  def add_station(route)
    puts 'Выберите станцию'
    stations_list
    stations_id = gets.chomp.to_i
    station = @stations[stations_id]
    raise 'Станция уже добавлена. Выберите другую станцию' if route.stations.include? station

    route.add_station(station)
    puts "Станция #{station.name} добавлена в маршрут #{route.name}"
  rescue RuntimeError => e
    puts e.message
    routes_menu
  end

  def remove_station(route)
    puts 'Выберите станцию'
    puts route.list
    stations_id = gets.chomp.to_i
    station = @stations[stations_id]
    route.delete_station(station)
    puts "Станция #{station.name} удалена "
  end

  def stations_menu
    loop do
      puts '1 Cоздать станцию'
      puts '2 Выбрать станцию'
      puts '3 Показать количество станций'
      puts '4 Выйти в меню'
      act = gets.chomp.to_i
      stations_menu_go(act)
    end
  end

  def stations_menu_go(act)
    case act
    when 1 then create_station
    when 2 then choose_station
    when 3 then puts "Всего станций: #{Station.instances}"
    when 4 then menu
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
  rescue ArgumentError
    create_station
  end

  def valid_station?(station)
    station.valid?
  #   true
  # rescue StandardError
  #   false
  end

  def choose_route_stations
    stations_list
    puts 'Введите номер начальной станции'
    first_id = gets.chomp
    puts 'Введите номер конечной станции'
    last_id = gets.chomp
    raise "Введите номера двух станций" if first_id.empty? || last_id.empty?
    route_stations = []
    route_stations << @stations[first_id.to_i]
    route_stations << @stations[last_id.to_i]
    create_route(first_id, last_id, route_stations)
  rescue RuntimeError => e
    puts e.message 
    retry 
  end

  def create_route(first_id, last_id, route_stations)
    stations_ids = first_id.to_s + last_id.to_s
    @routes[stations_ids] = Route.new(route_stations)
    route = @routes[stations_ids]
    puts "Маршрут #{route.name} создан"
  rescue RuntimeError => e
    puts e.message
    retry
  end

  def choose_station
    stations_list
    puts 'Введите id станции'
    id = gets.chomp.to_i
    station = @stations[id]
    puts "Выбрана станция #{station}"
    station_menu(station)
  end

  def station_menu(station)
    loop do
      puts '1 Проверить валидность названия станции'
      puts '2 Показать информацию о вагонах поездов на станции'
      puts '3 Показать информацию о списках поездов на станции (номер, тип, количество вагонов'
      puts '4 Выйти в меню'
      act = gets.chomp.to_i
      station_menu_go(act, station)
    end
  end

  def station_menu_go(act, station)
    case act
    when 1 then puts valid_station?(station)
    when 2 then each_train_wagons(station)
    when 3 then each_station_train(station)
    when 4 then stations_menu
    else
      menu
    end
  end

  def each_station_train(station)
    station.each_station_train
  rescue RuntimeError => e
    puts e.message
    stations_menu
  end

  def each_train_wagons(station)
    station.each_train_wagons
  rescue RuntimeError => e
    puts e.message
    stations_menu
  end

  def stations_list
    if @stations.any?
      @stations.each_with_index do |value, index|
        puts "id = #{index}  --- #{value.name}"
      end
    else
      puts 'Станций нет!'
      stations_menu
    end
  end

  def trains_number
    puts "Всего поездов: #{Train.instances}"
    puts "Всего пассажирских поездов: #{PassengerTrain.instances}"
    puts "Всего грузовых поездов: #{CargoTrain.instances}"
  end

  def find_train
    puts 'Введите номер поезда'
    train_id = gets.chomp.to_s
    if @trains.key?(train_id) == false
      puts 'Такого поезда нет (nil)'
    else
      train = (@trains[train_id])
      puts train
    end
  end

  def wagons_info(train)
    puts 'Список вагонов поезда с информацией о вагонах:'
    train.wagons_info
  end

  def add_wagons(train)
    raise 'Вагонов данного типа нет. Создайте вагон' if Wagon.nil?

    wagon = Wagon.all.keep_if { |w| w.wagon_type == train.train_type }

    wagon = wagon.sample
    train.add_wagon(wagon)
    puts "Вагон #{wagon} прицеплен к поезду номер #{train.number}"
  rescue NoMethodError => e
    puts e.inspect
    wagons_menu
  end

  def remove_wagons(train)
    train.remove_wagon
    puts 'Вагон отсоединен'
  end

  def show_wagons(train)
    puts 'Вагоны поезда: '
    puts train.show_wagons
  end

  def wagons_menu
    loop do
      puts 'Введите действие'
      puts '1 Создать вагон'
      puts '2 Выбрать вагон по номеру'
      puts '3 Выйти в меню'
      wagons_menu_go
    end
  end

  def wagons_menu_go
    id = gets.chomp.to_i
    case id
    when 1 then create_wagon
    when 2 then choose_wagon
    when 3 then menu
    end
  end

  def choose_wagon
    Wagon.all.each_with_index { |index, value| puts "Вагон #{value} номер #{index}" }
    puts 'Введите номер вагона'
    id = gets.chomp.to_i
    wagon = Wagon.all[id]
    return 'Вагона с таким номером нет' if wagon.nil?

    puts "Выбран вагон #{wagon} под номером #{id}"
    wagon.wagon_type == :passenger ? passenger_wagon_menu(wagon) : cargo_wagon_menu(wagon)
  end

  def create_wagon
    loop do
      puts 'Какой вагон создать?'
      puts '1 - Грузовой'
      puts '2 - Пасажирский'
      puts '3 - Выйти в меню'
      create_wagon_go
    end
  end

  def create_wagon_go
    case gets.chomp.to_i
    when 1 then create_cargo_wagon
    when 2 then create_passenger_wagon
    when 3 then wagons_menu
    end
  end

  def create_cargo_wagon
    puts 'Введите название производителя'
    firm = gets.chomp.to_s
    puts 'Укажите количество литров в вагоне'
    space = gets.chomp.to_i
    wagon = CargoWagon.new(firm, space)
    @wagons << wagon
    puts "Создан вагон #{wagon}"
  rescue RuntimeError => e
    puts e.inspect
    retry
  end

  def create_passenger_wagon
    puts 'Введите название производителя не менее трех букв'
    firm = gets.chomp.to_s
    puts 'Укажите количество мест в вагоне'
    seats = gets.chomp.to_i
    wagon = PassengerWagon.new(firm, seats)
    @wagons << wagon
    puts "Создан вагон #{wagon}"
  rescue RuntimeError => e
    puts e.inspect
    retry
  end

  def wagon_firm_name(wagon)
    puts wagon.firm_name
  end

  def take_seat(wagon)
    wagon.take_seat
    puts 'Вы заняли одно место в вагоне'
  end

  def seats_info(wagon)
    puts "Количество занятых мест в вагоне #{wagon.taken_seats}"
    puts "Количество свободных мест в вагоне #{wagon.free_seats}"
  end

  def take_space(wagon)
    puts 'Какой объем Вы хотите занять?'
    space = gets.chomp.to_i
    wagon.take_space(space)
    puts "Вы заняли #{space} литра (-ов) объема в вагоне"
  end

  def space_info(wagon)
    puts "Занятый объем составляет #{wagon.taken_space} литра (-ов)"
    puts "Свободный объем составляет #{wagon.free_space} литра (-ов)"
  end

  def valid_wagon?(wagon)
    wagon.valid?
  #   true
  # rescue StandardError
  #   false
  end

  def cargo_wagon_menu(wagon)
    loop do
      puts '1. Показать производителя'
      puts '2. Проверить валидность вагона'
      puts '3. Занять объем в вагоне'
      puts '4. Информация об объеме в вагоне'
      puts '5. Выйти в меню'
      cargo_wagon_menu_go(wagon)
    end
  end

  def cargo_wagon_menu_go(wagon)
    case gets.chomp.to_i
    when 1 then wagon_firm_name(wagon)
    when 2 then puts valid_wagon?(wagon)
    when 3 then take_space(wagon)
    when 4 then space_info(wagon)
    when 5 then wagons_menu
    end
  end

  def passenger_wagon_menu(wagon)
    loop do
      puts '1. Показать производителя'
      puts '2. Проверить валидность вагона'
      puts '3. Занять место в вагоне'
      puts '4. Информация о количестве мест в вагоне'
      puts '5. Выйти в меню'
      passenger_wagon_menu_go(wagon)
    end
  end

  def passenger_wagon_menu_go(wagon)
    act = gets.chomp.to_i
    case act
    when 1 then wagon_firm_name(wagon)
    when 2 then puts valid_wagon?(wagon)
    when 3 then take_seat(wagon)
    when 4 then seats_info(wagon)
    when 5 then wagons_menu
    end
  end

  def values_arrays_menu
    puts "Выберите класс"
    puts "1 Поезд"
    puts "2 Станция"
    puts "3 Маршрут"
    puts "4 Вагон"
    puts class_number = gets.chomp
    values_arrays_menu_go(class_number)
  end 

  def values_arrays_menu_go(class_number)
    attributes_class = CLASSES[class_number] 
    raise "Класс #{attributes_class} пуст" if attributes_class.all.nil?
    case class_number.to_i
    when 1 then trains_values 
    when 2 then stations_values
    when 3 then routes_values 
    when 4 then wagons_values 
    end 
    
  rescue RuntimeError => e
    puts e.message 
    menu 
  end 

  def trains_values
    @trains.each do |name, value|
      puts value 
      value.instance_variables.each do |attribute|
        puts value.send("#{attribute}_history".gsub('@','').to_sym)
      end 
    end 
  end 

  def stations_values
    @stations.each do |value|
      value.instance_variables.each do |attribute|
        puts value.send("#{attribute}_history".gsub('@','').to_sym)
      end 
    end 
  end 
  
  def routes_values
    @routes.each do |name, value|
      value.instance_variables.each do |attribute|
        puts value.send("#{attribute}_history".gsub('@','').to_sym)
      end 
    end 
  end 
  
  def wagons_values
    @wagons.each do |value|
      value.instance_variables.each do |attribute|
        puts value.send("#{attribute}_history".gsub('@','').to_sym)
      end 
    end 
  end 

  def validate_values
    puts "Выберите класс"
    puts "1 Поезд"
    puts "2 Станция"
    puts "3 Вагон"
    puts class_number = gets.chomp
    validate_values_go(class_number)
  end 

  def validate_values_go(class_number)
    attributes_class = CLASSES[class_number] 
    raise "Класс #{attributes_class} пуст" if attributes_class.all.nil?
    case class_number.to_i
    when 1 then trains_validate
    when 2 then stations_validate
    when 3 then wagons_validate 
    end 
  end 

  def trains_validate
    @trains.each do |name, value|
      puts "Объект: #{value}. Результат валидации:"
      puts "#{value.valid?}"
    end  
  end 

  def stations_validate
    @stations.each do |value|
      puts "Объект: #{value}. Результат валидации:"
      puts "#{value.valid?}" 
    end 
  end 
  
  def wagons_validate
    @wagons.each do |value|
      puts "Объект: #{value}. Результат валидации:"
      puts "#{value.valid?}"
    end 
  end 

end


Main.new.menu

