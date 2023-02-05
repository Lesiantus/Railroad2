class PassengerWagon < Wagon
  attr_reader :used_volume

  def initialize(volume)
    super
    @type = :passenger
  end

  def ticket_sell
    raise 'В вагоне кончились посадочные места' if @volume == @used_volume

    @used_volume += 1
  end
end
