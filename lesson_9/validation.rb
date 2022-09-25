module Validation
  def validate(attribute, validation_type, *args)
    
    define_method(:validate!) do   
      attribute_value = instance_variable_get("@#{attribute}")
      # не всё проверяет!
      case validation_type 
      when :presence
        raise "Значение #{attribute} пустое" if attribute_value.nil? || attribute_value.empty?
        
      when :format
        raise "Неверный формат значения #{attribute}" if attribute_value !~ self.class.const_get(args[0]) 
      
      when :type
        raise "Тип #{attribute} не соответствует классу #{self.class.to_s} аттрибута" if self.class.to_s != args[0].to_s
      end 
    end 

    
    define_method(:valid?) do 
      puts validate!
      puts true 
    rescue RuntimeError => e
      puts false
      puts e.message 
    end 
    
  end 
end

