module Manufacturer
  attr_accessor :firm 
  def define_firm(firm)
    self.firm = firm
  end 
  
  def firm_name
    self.firm 
  end 
end 