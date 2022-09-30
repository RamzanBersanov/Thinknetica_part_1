module Accessors
  
  def attr_accessor_with_history(*names)
    names.each do |name|      
      history = []
      
      define_method(name) { instance_variable_get("@#{name}")}

      define_method("#{name}=".to_sym) do |value|
        history << instance_variable_set("@#{name}", value)
      end

      # значения из initialize нет, остальные есть
      define_method("#{name}_history".to_sym) do 
        "Массив значений переменной #{name}: #{history}" 
      end 
    end
  end 

  def strong_attr_accessor(*names)
    var_class_name = self.name
    names.each do |name|

      define_method(name) {instance_variable_get("@#{name}")}
      
      define_method("#{name}=".to_sym) do |input|
        var = input[0]
        var_class = input[1]
        if "#{var_class_name}".to_s == var_class.to_s.capitalize 
          instance_variable_set("@#{name}", var) 
        else
          raise RuntimeError, "Класс указан неверно" 
        end 
      rescue RuntimeError => e
        puts e.message
      end 
      
    end 
  end   
  
end 