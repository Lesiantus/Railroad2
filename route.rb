class Route
  include InstanceCounter

  attr_accessor :stations, :depart, :arrive

  def initialize(depart, arrive)
    @stations = [depart, arrive]
    register_instance
  end

  def add_station(station)
    self.stations.insert(rand(1..self.stations.size-1), station)
  end

  def delete_station(station)
    if [stations.first, stations.last].include?(station)
      puts "Невозможно удалить первую и последнюю станцию маршрута"
    else
      self.stations.delete(station)
    end
  end

  def show_stations
    puts stations.map{|el| el.name}
  end
end
