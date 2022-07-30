module Manufacturer
  attr_accessor :firm 
  def define_firm(firm)
    self.firm = firm
  end 
  
  def show_firm
    puts "Название фирмы - #{self.firm}"
  end 
end 