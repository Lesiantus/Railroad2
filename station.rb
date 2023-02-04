class Station

  include InstanceCounter
  include Valid

  @@stations = []

  attr_reader :trains, :name

  def initialize(name)
    @name = name
    @trains=[]
    validate!
    @@stations << self
    register_instance

  end

  def self.all
    @@instances.inspect
  end

  def arrival(train)
    @trains<<train
  end

  def trains_on_station
    @trains.map { |key, value| return key, value }
  end

  def trains_by_type(type)
    @trains.map{ |key, value| puts key.number, key.type if key.type == type }
  end

  def train_depart(train)
    @trains.delete(train)
    train.station=nil
  end

  def block_for_trains(&block)
    @trains.each {|train| block.call(train)}
  end

  protected

  def validate!
    raise "Станция не может быть без названия!" if name.empty?
  end
end
