# frozen_string_literal: true

class CargoWagon < Wagon
  attr_accessor_with_history :space, :taken_space, :free_space
  validate :wagon_type, :type, :passenger
  
  def initialize(firm, space)
    self.wagon_type = :cargo
    super(firm)
    self.space = space
    self.taken_space = 0
    self.free_space = space
  end
  
  def validate!
    super
    raise 'Неверный тип вагона' if @wagon_type != :cargo
  end
  
  def take_space(space)
    @free_space = @free_space -= space
    @taken_space = @space - @free_space
  end
end
