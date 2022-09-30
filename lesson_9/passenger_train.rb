# frozen_string_literal: true

class PassengerTrain < Train

  attr_accessor_with_history :type
  validate :number, :type, PassengerTrain
  
    def initialize(number)
      super(number)
      self.type = :passenger
      validate!(:number, :type, PassengerTrain)
    end
  end