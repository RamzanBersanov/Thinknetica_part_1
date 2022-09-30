# frozen_string_literal: true

class CargoWagon < Wagon
  # валидировать объем
  attr_accessor_with_history :space, :taken_space, :free_space, :type
  validate :firm, :type, CargoWagon
  validate :space, :presence
  
  def initialize(firm, space)
    self.type = :cargo
    self.space = space
    # self.taken_space = 0
    # self.free_space = space
    super(firm)
    validate!(:space, :presence)
    validate!(:firm, :type, CargoWagon)
    register_instance
  end

  
  def take_space(space)
    @free_space = @free_space -= space
    @taken_space = @space - @free_space
  end
end