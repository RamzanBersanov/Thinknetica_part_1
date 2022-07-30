
class CargoTrain < Train
  def initialize(number)
    super(number)
    @train_type = :cargo
  end
end
