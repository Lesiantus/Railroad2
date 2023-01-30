class Train
  attr_accessor :speed, :station, :route, :wagons
  attr_reader :wagon, :type, :number


  def initialize(number, type)
    @number = number
    @type = type
    @wagons = []
    @speed = 0
  end

  def stop
    @speed=0
  end

  def wagon_add(wagon)
    if @speed == 0
      @wagons << wagon
    else
      puts "Поезд должен стоять"
    end
  end

  def wagon_remove(wagon)
    if @wagons.include?(wagon) && speed == 0
      @wagons.delete(wagon)
      puts "был отцеплен вагон"
    elsif speed == 0 && !wagons.include?(wagon)
      puts "такого вагона нет в списке вагонов поезда"
    else
      puts "Поезд должен стоять"
    end
  end

  def add_route(route)
    self.route=route
  end
  def next_station(station)
    if route.nil?
      puts "Нет маршрута"
    elsif route.stations.include?(station)
      @station.train_depart(self) if @station
      @station = station
      station.arrival(self)
    end
  end

  def next_previous
    if route.nil?
      puts "Нет маршрута"
    else
      station_index = route.stations.index(station)
      puts "Текущая станция: #{station.name}."
      puts "Предыдущая - #{route.stations[station_index - 1].name}." if station_index != 0
      puts "Следующая - #{route.stations[station_index + 1].name}." if station_index != route.stations.size - 1
    end
  end
end
