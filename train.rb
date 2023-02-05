require_relative 'instance_counter'
require_relative 'manufacturer'
require_relative 'valid'
class Train
  NUMBER_FORMAT = /^[a-zа-я0-9]{3}-?[a-zа-я0-9]{2}$/i.freeze

  include Manufacturer
  include InstanceCounter
  include Valid

  @@trains = {}

  attr_accessor :speed, :station, :route, :wagons
  attr_reader :wagon, :type, :number

  def initialize(number)
    @number = number
    @wagons = []
    @speed = 0
    @@trains[number] = self
    validate!
    register_instance
  end

  def self.find(number)
    @@trains[number]
  end

  def stop
    @speed = 0
  end

  def add_wagon(wagon)
    if @speed.zero? && wagon.type == type
      @wagons << wagon
    else
      puts 'Поезд должен стоять'
    end
  end

  def wagon_remove(wagon)
    if @wagons.include?(wagon) && speed.zero?
      @wagons.delete(wagon)
      puts 'был отцеплен вагон'
    elsif speed.zero? && !wagons.include?(wagon)
      puts 'такого вагона нет в списке вагонов поезда'
    else
      puts 'Поезд должен стоять'
    end
  end

  def add_route(route)
    self.route = route
  end

  def next_station(station)
    if route.nil?
      puts 'Нет маршрута'
    elsif route.stations.include?(station)
      @station&.train_depart(self)
      @station = station
      station.arrival(self)
    end
  end

  def next_previous
    if route.nil?
      puts 'Нет маршрута'
    else
      station_index = route.stations.index(station)
      puts "Текущая станция: #{station.name}."
      puts "Предыдущая - #{route.stations[station_index - 1].name}." if station_index != 0
      puts "Следующая - #{route.stations[station_index + 1].name}." if station_index != route.stations.size - 1
    end
  end

  def block_for_wagons(&block)
    @wagons.each { |wagon| block.call(wagon) }
  end

  protected

  def validate!
    raise 'поезд не может не иметь номера' if number.nil?
    raise 'номер должен иметь 5 символов в формате ххх-хх, или ххххх' if number.length < 5
    if number !~ NUMBER_FORMAT
      raise 'неподдерживаемый формат номера, номер должен иметь 5 символов в формате ххх-хх, или ххххх'
    end

    true
  end
end
