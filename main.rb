require_relative 'manufacturer'
require_relative 'instance_count'
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
      puts " id #{index} #{value.stations}"
    end
  end

  def getting_route(train)
    puts "Выбран поезд #{train}"
    puts 'Введите номер маршрута'
    route_list
    route_name = gets.chomp.to_s
    route_value = @routes[route_name]

    @trains[train.number].getting_route(route_value)
  end

  def route_menu(route)
    loop do
      puts "1 Добавить станцию в маршруте #{route} "
      puts "2 Удалить станцию в маршруте #{route} "
      
      act = gets.chomp.to_i
      case act
      when 1 then add_station(route)
      when 2 then remove_station(route)
      
      else
        break
      end
    end
  end

  def add_station(route)
    puts 'Выберете станцию'
    stations_list
    stations_id = gets.chomp.to_i
    route.add_station(@stations[stations_id])
  end

  def remove_station(route)
    puts 'Выберите станцию'
    puts route.list

    stations_id = gets.chomp.to_i
    route.delete_station(@stations[stations_id])
  end
  
  def stations_menu
    loop do
      puts '1 Cоздать станцию'
      puts '2 Посмотреть список станций'
      puts '3 Показать количество станций'
      act = gets.chomp.to_i
      case act
      when 1 then create_station
      when 2 then stations_list
      when 3 then puts "Всего станций: #{Station.instances}" 
      else
        break
      end 
    end
  end

  def create_station
    puts 'Введите название станции'
    name = gets.chomp.to_s
    s = Station.new(name)
    @stations << s
    puts "Станция #{name} создана "
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
      puts '1 Выбрать поезд'
      puts '2 Создать поезд'
      puts '3 Найти поезд по номеру'
      puts '4 Показать количество всех поездов'
      puts '5 Показать количество пассажирских поездов поездов'
      puts '6 Показать количество грузовых поездов'
      case gets.chomp.to_i
      when 1
        if @trains.any?
          puts 'Выберите поезд'
          trains_list
          train = gets.chomp.to_i
          train_menu(@trains[train])
        else
          puts 'Поездов нет'

        end
      when 2 then create_train
      when 3 then find_train
      when 4 then puts puts "Всего поездов: #{Train.instances}"
      when 5 then puts puts "Всего пассажирских поездов: #{PassengerTrain.instances}"
      when 6 then puts puts "Всего грузовых поездов: #{CargoTrain.instances}"
      else
        break
      end
    end
  end

  def find_train
    puts "Введите номер поезда"
    train_id = gets.chomp.to_i
    if @trains.has_key?(train_id) == false
      puts "Такого поезда нет (nil)" 
    else 
      train = (@trains[train_id])
      train.find
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
      
      act = gets.chomp.to_i
      case act
      when 1 then add_wagons(train)
      when 2 then remove_wagons(train)
      when 3 then getting_route(train)
      when 4 then next_station(train)
      when 5 then prev_station(train)
      when 6 then define_train_firm(train)
      when 7 then show_firm(train)
      when 8 then show_wagons(train)
      else
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
      if wagon.empty?
        puts "Вагонов грузового типа нет. Создайте вагон"
      else
        wagon = wagon.sample
        train.add_wagon(wagon)
      end 
    elsif wagon_type == 2
      wagon = Wagon.all_wagons.keep_if { |wagon| wagon.wagon_type == :passenger } 
      if wagon.empty?
        puts "Вагонов пассажирского типа нет. Создайте вагон"
      else
        wagon = wagon.sample
        train.add_wagon(wagon)
      end 
    end 
  end

  def remove_wagons(train)
    train.remove_wagon
    puts 'Вагон отсоединен'
  end

  def show_wagons(train)
    puts "Вагоны поезда: "
    train.show_wagons
  end
  
  def create_train
    loop do
      puts 'Какой поезд создать?'
      puts '1. Грузовой,'
      puts '2. Пасажирский'
      train_type = gets.chomp.to_i

      case train_type
      when 1
        puts 'Введите номер поезда'
        train_number = gets.chomp.to_i
        create_cargo_train(train_number)

      when 2
        puts 'Введите номер поезда'
        train_number = gets.chomp.to_i
        create_passenger_train(train_number)

      else
        break
      end
    end
  end


  def define_train_firm(train)
    puts "Введите название фирмы"
    firm = gets.chomp
    train.define_firm(firm)
  end 

  def show_firm(train)
    train.show_firm
  end 

  def create_cargo_train(train_number)
    @trains[train_number] = CargoTrain.new(train_number)
    puts "Поезд #{train_number} создан"
  end

  def create_passenger_train(train_number)
    @trains[train_number] = PassengerTrain.new(train_number)
    puts "Поезд #{train_number} создан"
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
      when 1 
        puts 'Какой вагон создать?'
        puts '1 - Грузовой'
        puts '2 - Пасажирский'
      
        wagon_type = gets.chomp.to_i
          #укажите фирму
          
        wagon = if wagon_type == 1
                  CargoWagon.new
                else
                  PassengerWagon.new
                end
      
        
        puts 'Введите название производителя'
        firm = gets.chomp.to_s
        wagon.define_firm(firm)
        
      when 2
        Wagon.show_wagons
        puts 'Введите номер вагона'
        id = gets.chomp.to_i
        wagon = Wagon.all_wagons[id]
        show_firm(wagon) 
      else
        break
      end 
      end 
    end 
  end


  def show_firm(wagon) 
    wagon.show_firm 
  end 

  def wagon_menu(wagon)
    loop do
      puts "Выбран вагон #{train.number}"
      puts '1 Показать производителя'
      act = gets.chomp.to_i
      case act
      when 1
        wagon.show_firm
      else
        break
      end
    end


  

end


Main.new.go