module CustomAttrAccessor
  def attr_accessor_with_history(*names)
    names.each do |name|
      variable = "@#{name}".to_sym
      define_method(name) { instance_variable_get(variable) }
      define_method("#{name}=".to_sym) do |value|
        instance_variable_set(variable, value)
        @history ||= {}
        @history[name] ||= []
        @history[name] << value
      end
      define_method("#{name}_history") { @history ? @history[name] : [] }
    end
  end

  def strong_attr_accessor(name, type)
    raise TypeError, 'Должен быть символ' unless name.is_a?(Symbol)
    define_method(name) { instance_variable_get("@#{name}") }
    define_method("#{name}=") do |value|
      raise TypeError, "#{name} не от #{type}" unless value.class.eql?(type)
      instance_variable_set(name, value)
    end
  end
end
