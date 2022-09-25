# frozen_string_literal: true

class PassengerTrain < Train

  validate :number, :train_type, PassengerTrain
  
    def initialize(number)
      super(number)
      self.train_type = :passenger
    end
  end