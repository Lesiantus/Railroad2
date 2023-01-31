class Station
  attr_reader :trains, :name

  def initialize(name)
    @name = name
    @trains=[]
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
end