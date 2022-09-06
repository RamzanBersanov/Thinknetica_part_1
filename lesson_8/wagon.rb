# frozen_string_literal: true

class Wagon
  FIRM = /\w{3}+/.freeze
  include Manufacturer
  include InstanceCounter

  attr_reader :wagon_type

  def initialize(firm)
    define_firm(firm)
    validate!
    register_instance
  end

  def validate!
    raise 'Название фирмы не должно быть короче трех букв' if firm !~ FIRM
  end
end
