# frozen_string_literal: true

module Manufacturer
  attr_accessor :firm

  def define_firm(firm)
    self.firm = firm
  end

  def firm_name
    firm
  end
end
