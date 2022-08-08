class CargoWagon < Wagon
  def initialize(firm)
    @wagon_type = :cargo
    super(firm)
  end

  def validate!
    super
    raise "Неверный тип вагона" if @wagon_type != :cargo
  end 
end