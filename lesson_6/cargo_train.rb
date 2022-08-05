class CargoTrain < Train
  def initialize(number)
    super(number)
    @train_type = :cargo
  end 

  def validate! #думаю, что здесь это не нужно, так как пользователь выбирает тип поезда при создании в меню, а не указывает сам
    super
    raise "Неверный тип поезда" if @train_type != :cargo
  end 
  
end 