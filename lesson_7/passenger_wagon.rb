class PassengerWagon < Wagon
  
  def initialize(firm, space)
    @wagon_type = :passenger
    super(firm, space)
  end

  def validate!
    super
    raise "Неверный тип вагона" if @wagon_type != :passenger
  end 

  def take_passenger_space 
    @free_space = @free_space -= 1
  end
  
end
