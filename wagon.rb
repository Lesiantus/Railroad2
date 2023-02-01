class Wagon
  include InstanceCounter
  include Manufacturer
  attr_reader :type
  def initialize
    register_instance
  end
end
