# frozen_string_literal: true

module InstanceCounter
  module ClassMethods
    attr_accessor :instances, :all

    def inherited(subclass)
      super
      subclass.instance_eval do
        @all = []
        @instances = 0
      end
    end

    def add_instance(instance)
      cls = self

      cls.all = cls.all.to_a << instance
      cls.instances = cls.instances.to_i + 1
    end
  end

  module InstanceMethods
    protected

    def register_instance
      cls = self.class

      cls.add_instance(self)

      loop do
        cls = cls.superclass

        break unless cls.included_modules.include?(InstanceCounter)

        cls.add_instance(self)
      end
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
  end
end
