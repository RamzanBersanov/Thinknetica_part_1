class Wagon
  FIRM = /\w{3}+/
  include Manufacturer
  include InstanceCounter

  attr_reader :wagon_type
  
  def initialize(firm)
    @firm = firm
    validate! 
    register_instance
  end 

  def validate!
    raise "Название фирмы не должно быть короче трех букв" if self.firm !~ FIRM
  end  
end 
