class PassengerWagon < Wagon
  
  attr_reader :seats, :taken_seats, :free_seats
  
  def initialize(firm, seats)
    @wagon_type = :passenger
    super(firm)
    @seats = seats  
    @taken_seats = 0
    @free_seats = seats  
  end

  def validate!
    super
    raise "Неверный тип вагона" if @wagon_type != :passenger
  end 

  def take_seat
    @free_seats = @free_seats -= 1
    @taken_seats = @seats - @free_seats
  end  
  
end