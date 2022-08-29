class CargoWagon < Wagon
  
  def initialize(firm, space)
    @wagon_type = :cargo
    super(firm, space) 
  end

  def validate!
    super
    raise "Неверный тип вагона" if @wagon_type != :cargo
  end 

  def take_cargo_space(space)
    @free_space = @free_space -= space
  end   
  
end