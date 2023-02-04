
class CargoWagon<Wagon
  attr_reader :used_volume
  def initialize(volume)
    super
    @type = :cargo
  end


  def fill_in(volume)
    raise "В вагоне нет столько свободного места!" if volume + @used_volume > @volume
    @used_volume += volume
  end


end

