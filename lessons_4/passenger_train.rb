class PassengerTrain < Train
    def initialize(number)
      super(number)
      @train_type = :passenger
    end
  end