class PassengerWagon < Wagon
  def initialize
    @wagon_type = :passenger
    super
  end

  def validate!
    super
    raise "Неверный тип вагона" if @wagon_type != :passenger
  end 
end