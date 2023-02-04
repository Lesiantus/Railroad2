class Wagon
  include InstanceCounter
  include Manufacturer
  attr_reader :type, :number
  def initialize(volume)
    @number = rand(1..200)
    @volume = volume
    @used_volume = 0
    register_instance
  end

  def free_space
    @volume - @used_volume
  end

end
