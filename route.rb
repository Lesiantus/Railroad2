class Route
  include InstanceCounter
  include Validation

  attr_accessor :stations, :depart, :arrive
  validate :depart, :type, :Station

  def initialize(depart, arrive)
    @stations = [depart, arrive]
    validate!
    register_instance
  end

  def add_station(station)
    stations.insert(rand(1..stations.size - 1), station)
  end

  def delete_station(station)
    if [stations.first, stations.last].include?(station)
      puts 'Невозможно удалить первую и последнюю станцию маршрута'
    else
      stations.delete(station)
    end
  end

  def show_stations
    puts stations.map(&:name)
  end

  protected

  def validate!
    raise 'Должно быть две станции при указании маршрута' if stations.size < 2
  end
end
