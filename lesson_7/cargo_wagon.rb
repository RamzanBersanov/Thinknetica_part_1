class CargoWagon < Wagon

  attr_reader :space, :taken_space, :free_space
  
  def initialize(firm, space)
    @wagon_type = :cargo
    super(firm)
    @space = space
    @taken_space = 0
    @free_space = space  
  end

  def validate!
    super
    raise "Неверный тип вагона" if @wagon_type != :cargo
  end 

  def take_space(space) #объем указывается в качестве параметра метода
    @free_space = @free_space -= space
    @taken_space = @space - @free_space
  end  
  
end