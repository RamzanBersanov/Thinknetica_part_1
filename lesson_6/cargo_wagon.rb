class CargoWagon < Wagon
  def initialize
    @wagon_type = :cargo
    super
  end

  def validate!
    super
    raise "Неверный тип вагона" if @wagon_type != :cargo
  end 
end