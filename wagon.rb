class Wagon
  include InstanceCounter
  include Manufacturer
  attr_reader :type
  def initialize
    initialize_instance
  end
end
