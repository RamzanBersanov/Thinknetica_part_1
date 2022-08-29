class Wagon
  
  attr_reader :space, :taken_space, :free_space
  
  FIRM = /\w{3}+/
  include Manufacturer
  include InstanceCounter

  attr_reader  :wagon_type
  
  def initialize(firm, space)
    define_firm(firm)
    validate! 
    register_instance
    @space = space
    @taken_space = 0
    @free_space = @space - @taken_space
  end 

  def validate!
    raise "Название фирмы не должно быть короче трех букв" if self.firm !~ FIRM
  end 

  def taken_space
    @space - @free_space
  end 
end 
