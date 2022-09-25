# frozen_string_literal: true

class Wagon
  FIRM = /[a-z]{3}+/.freeze
  include Manufacturer
  include InstanceCounter
  extend Accessors
  extend Validation

  validate :firm, :format, :FIRM
  
  attr_accessor_with_history :wagon_type, :firm
  # strong_attr_accessor :wagon_type, :firm 
  
  def initialize(firm)
    self.firm = firm
    validate!
    register_instance
  end
  
  # def validate!
  #   raise 'Название фирмы не должно быть короче трех букв' if firm !~ FIRM
  # end
end
