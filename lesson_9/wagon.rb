# frozen_string_literal: true

class Wagon
  FIRM = /[a-z]{3}+/.freeze
  include Manufacturer
  include InstanceCounter
  extend Accessors
  extend Validation

  validate :firm, :presence
  validate :firm, :format, :FIRM
  
  attr_accessor_with_history :firm
  
  def initialize(firm)
    self.firm = firm
    validate!(:firm, :presence)
    validate!(:firm, :format, :FIRM)
  end

end