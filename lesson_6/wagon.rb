class Wagon
  FIRM = /\w{3}+/
  include Manufacturer

  attr_reader :wagon_type

  @@all_wagons = []

  def self.all_wagons
    @@all_wagons
  end 
  
  def initialize
    @@all_wagons << self 
  end 

  def self.all_wagons
    @@all_wagons
  end 

  def validate!
    raise "Название фирмы не должно быть короче трех букв" if self.firm !~ FIRM
  end  
end 
