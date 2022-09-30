module Validation
  
  def validate(attribute, validation_type, *args)
    
    define_method(:validate!) do |attribute, validation_type, *args|   
      case validation_type 
        
      when :presence
        raise "Значение #{attribute} пустое" if instance_variable_get("@#{attribute}").to_s.nil? || instance_variable_get("@#{attribute}").to_s.empty? || instance_variable_get("@#{attribute}") == 0
        
      when :format
        raise "Неверный #{validation_type} значения  #{attribute}" if instance_variable_get("@#{attribute}") !~ self.class.const_get(args[0])
        
      when :type
        raise "Тип переменной #{attribute} не соответствует классу #{args[0].to_s} аттрибута" if self.class.to_s != args[0].to_s
        
      end 
      
    end 

    define_method(:valid?) do 
      validate!(attribute, validation_type, *args)
      puts true
    rescue RuntimeError => e
      puts false
    end 
    
  end 
  
end