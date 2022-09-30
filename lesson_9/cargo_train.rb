# frozen_string_literal: true

class CargoTrain < Train

  attr_accessor_with_history :type
  validate :number, :type, CargoTrain 
  
    def initialize(number)
      super(number)
      self.type = :cargo
      validate!(:number, :type, CargoTrain)
    end
  end