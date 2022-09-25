# frozen_string_literal: true

class CargoTrain < Train
  extend Accessors

  validate :number, :train_type, CargoTrain
  
    def initialize(number)
      super(number)
      self.train_type = :cargo
    end
  end
