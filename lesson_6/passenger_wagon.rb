class PassengerWagon < Wagon
  def initialize(firm)
    @wagon_type = :passenger
    super(firm)
  end

  def validate!
    super
    raise "Неверный тип вагона" if @wagon_type != :passenger
  end 
end