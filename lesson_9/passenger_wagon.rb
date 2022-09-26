# frozen_string_literal: true

class PassengerWagon < Wagon
  attr_accessor_with_history :seats, :taken_seats, :free_seats
  validate :wagon_type, :type, :passenger
  
  def initialize(firm, seats)
    self.wagon_type = :passenger
    super(firm)
    self.seats = seats
    self.taken_seats = 0
    self.free_seats = seats
  end
  
  def validate!
    super
    raise 'Неверный тип вагона' if @wagon_type != :passenger
  end
  
  def take_seat
    @free_seats = @free_seats -= 1
    @taken_seats = @seats - @free_seats
  end
end
