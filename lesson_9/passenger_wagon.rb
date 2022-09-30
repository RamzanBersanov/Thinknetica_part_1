# frozen_string_literal: true

class PassengerWagon < Wagon
  attr_accessor_with_history :seats, :taken_seats, :free_seats, :type
  validate :firm, :type, PassengerWagon
  validate :seats, :presence
  
  def initialize(firm, seats)
    self.type = :passenger
    self.seats = seats
    # self.taken_seats = 0
    # self.free_seats = seats
    super(firm)
    validate!(:seats, :presence)
    validate!(:firm, :type, PassengerWagon)
    register_instance
  end
  
  def take_seat
    @free_seats = @free_seats -= 1
    @taken_seats = @seats - @free_seats
  end
end
