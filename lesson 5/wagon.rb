class Wagon
  include Manufacturer

  attr_reader :wagon_type

  @@all_wagons = []

  def self.all_wagons
    @@all_wagons
  end 
  
  def initialize
    @@all_wagons << self 
  end 

  def self.show_wagons
    @@all_wagons.each_with_index { |wagon, index| puts " #{index} #{wagon} " }
  end 

  #{wagon.show_firm}
  
end 
