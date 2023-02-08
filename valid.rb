module Validation
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    attr_reader :validations
    def validate(method, type, *args)
      @validations ||= []
      @validations << { method: method, type: type, args: args }
    end
  end

  module InstanceMethods
    def valid?
      validate!
    rescue
      false
    end

    protected

    def validate!
      raise "В классе нет аргументов для проверки: #{self.class}" if self.class.validations.nil?
      self.class.validations.each do |validation|
        validation[:attr_value] = instance_variable_get("@#{validation[:method]}")
        send validation[:type], validation
      end
      true
    end

    def presence(options)
      raise "Атрибут #{options[:method]} класса #{self.class} не может быть пустым" if options[:attr_value].to_s.empty?
    end

    def format(options)
      error_msg = "Ошибка! Не правильный формат атрибута #{options[:method]} в классе #{self.class}"
      raise error_msg if options[:attr_value] !~ options[:args].first
    end

    def type(options)
      raise "Аргумент #{options[:method]} должен быть #{options[:args].first}" unless options[:attr_value].is_a?(options[:args].first)
    end
  end
end
