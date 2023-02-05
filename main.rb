require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'wagon'
require_relative 'passenger_wagon'
require_relative 'cargo_wagon'
require_relative 'route'
require_relative 'station'
require_relative 'manufacturer'
require_relative 'instance_counter'

class Main
  WAGON = { cargo: CargoWagon, passenger: PassengerWagon }.freeze
  def initialize
    @stations = []
    @trains = []
    @routs = []
  end

  def start
    loop do
      show_menu
      choice = input_choice
      action(choice)
      break if @choice.zero?
    end
  end

  def show_menu
    puts %(
    1 Создать станцию
    2 Создать поезд
    3 Создать маршрут
    4 Добавить станцию в маршрут
    5 Удалить станцию из маршрута
    6 Назначить маршрут поезду
    7 Добавить вагон к поезду
    8 Отцепить вагон отпоезда
    9 Переместить поезд по маршруту
    10 Просмотреть список станций
    11 Просмотреть список поездов
    12 Посмотреть список поездов для конкретной станции
    13 Показать список всех станций и находящиеся на них поезда
    14 Список вагонов для поезда, управление свободным местом
    0 Выход
    )
  end

  def input_choice
    puts 'Введите номер операции'
    @choice = $stdin.gets.chomp.to_i
  end

  def action(_choice)
    case @choice
    when 1
      add_station
    when 2
      add_train
    when 3
      create_route
    when 4
      route_station_add
    when 5
      route_station_delete
    when 6
      add_route_to_train
    when 7
      add_wagon_to_train
    when 8
      delete_wagon_from_train
    when 9
      move_train
    when 10
      stations_list
    when 11
      trains_list
    when 12
      trains_on_station
    when 13
      all_stations_and_trains_on
    when 14
      wagon_list_for_train
    end
  end

  def trains_list
    @trains.map { |el| puts el.number }
  end

  def stations_list
    @stations.map { |el| puts el.name }
  end

  def all_stations_and_trains_on
    @stations.each do |station|
      puts "станция #{station.name}"
      next if station.trains.empty?

      station.block_for_trains do |train|
        puts "имеет поезд номер #{train.number} #{train.type} #{train.wagons.count}"
      end
    end
  end

  def wagon_list_for_train
    raise 'Нужно создать поезд' if @trains.empty?

    puts 'Введите номер поезда'
    number = $stdin.gets.chomp
    train = @trains.detect { |trains| trains.number == number }
    raise 'такого поезда нет' if train.nil?

    train.block_for_wagons do |wagon|
      puts "#{wagon.number} #{wagon.type} свободно #{wagon.free_space} занято #{wagon.used_volume}"
    end
    puts 'Управление свободным местом в вагоне: введите 1 для того, чтобы занять место, 2 для выхода в меню'
    input = $stdin.gets.chomp.to_i
    raise 'неверный ввод, можно управлять, нажав клавишу 1 или 2!' unless [1, 2].include?(input)

    case input
    when 1
      puts 'Введите номер вагона'
      wagon_number = $stdin.gets.chomp.to_i
      wagon = train.wagons.detect { |wagons| wagons.number == wagon_number }
      raise 'такой вагона нет у выбранного поезда' if wagon.nil?

      case wagon.type
      when :cargo
        raise 'нет свободного места!' if wagon.free_space.zero?

        puts "свободно места #{wagon.free_space}, сколько заполнить?"
        space = $stdin.gets.chomp.to_i
        wagon.fill_in(space)
      when :passenger
        raise 'нет свободного места!' if wagon.free_space.zero?

        wagon.ticket_sell
        puts "свободных мест осталось #{wagon.free_space}"
      end
    when 2
      show_menu
    end
  rescue RuntimeError => e
    puts e.message
  end

  def trains_on_station
    raise 'сначала создайте станцию' if @stations.empty?

    puts 'Укажите станцию для вывода списка поездов'
    input = $stdin.gets.chomp
    station = @stations.detect { |stations| stations.name == input }
    raise 'такой станции еще не создано' if station.nil?

    station.block_for_trains { |train| puts "#{train.number} #{train.type} #{train.wagons.count}" }
    puts 'Просмотр вагонов для поезда (введите номер поезда)'
    input2 = $stdin.gets.chomp
    train = station.trains.detect { |trains| trains.number == input2 }
    raise 'такого поезда нет на станции' if train.nil?

    train.block_for_wagons do |wagon|
      puts "Номер #{wagon.number} свободно #{wagon.free_space} занято #{wagon.used_volume}"
    end
  rescue RuntimeError => e
    puts e.message
  end

  def move_train
    raise 'Нужно создать поезд' if @trains.empty?
    raise 'Нужно создать станцию' if @stations.empty?

    puts 'Выберите номер поезда'
    number = $stdin.gets.chomp
    train_number = @trains.detect { |train| train.number == number }
    if train_number.nil?
      puts 'Такого поезда еще не создано'
    elsif train_number.route.nil?
      puts 'поезду еще не присвон маршрут'
    else
      puts 'Введите станцию, на которую вы хотите отправить поезд'
      input = $stdin.gets.chomp
      station = @stations.detect { |stations| stations.name == input }
      if train_number.route.stations.include?(station)
        train_number.next_station(station)
        puts "Поезд помещен на станцию #{station.name}"
      end
    end
  rescue RuntimeError => e
    puts e.message
  end

  def delete_wagon_from_train
    raise 'Сначала нужно создать поезд' if @trains.empty?

    puts 'Введите номер поезда для удаления вагона'
    number = $stdin.gets.chomp
    train_number = @trains.detect { |train| train.number == number }
    if train_number.nil?
      puts 'Такого поезда еще нет в списке поездов'
    elsif train_number.wagons.empty?
      puts 'У этого поезда нет прицепленных вагонов'
    else
      train_number.wagon_remove(train_number.wagons.last)
      puts "поузду номер #{number} был отцеплен вагон"
    end
  rescue RuntimeError => e
    puts e.message
  end

  def add_wagon_to_train
    raise 'Сначала необходимо создать поезд' if @trains.empty?

    puts 'Введите номер поезда для добавления вагона'
    number = $stdin.gets.chomp
    train = @trains.detect { |trains| trains.number == number }
    if train.nil?
      puts 'Такого поезда еще нет в списке поездов'
    elsif train.type == :cargo
      puts 'Введите объем вагона'
      volume = $stdin.gets.chomp.to_i
      puts "поезду номер #{number} был добавлен вагон"
    elsif train.type == :passenger
      puts 'Введите количество посадочных мест вагона'
      volume = $stdin.gets.chomp.to_i
    end
    train.add_wagon(WAGON[train.type].new(volume))
  rescue RuntimeError => e
    puts e.message
    retry unless @trains.empty?
  end

  def add_route_to_train
    raise 'Сначала необходимо создать поезд' if @trains.empty?
    raise 'Сначала необходимо создать станцию' if @stations.empty?

    puts 'Введите номер поезда для присвоения маршрута'
    number = $stdin.gets.chomp
    train_number = @trains.detect { |train| train.number == number }
    if train_number.nil?
      puts 'Такого поезда еще нет в списке поездов'
    else
      train_number.add_route(@routs[0])
      puts "Поезду #{number} был назначен маршрут"
    end
  rescue RuntimeError => e
    puts e.message
  end

  def route_station_delete
    raise 'Сначала необходимо создать маршрут' if @routs.empty?

    puts 'Введите название станции из списка созданных ранее'
    station_delete = $stdin.gets.chomp
    deleting_station = @routs[0].stations.detect { |station| station.name == station_delete }
    if deleting_station.nil?
      puts 'такой станции еще нет в списке'
    else
      puts "Удалена станция из маршрута следования #{deleting_station}"
      @routs[0].delete_station(deleting_station)
    end
  rescue RuntimeError => e
    puts e.message
  end

  def route_station_add
    raise 'Сначала необходимо создать станцию' if @stations.empty?
    raise 'Сначала необходимо создать маршрут' if @routs.empty?

    puts 'Введите название станции из списка созданных ранее'
    station_add = $stdin.gets.chomp
    adding = @stations.detect { |station| station.name == station_add }
    if adding.nil?
      puts 'такой станции еще нет в списке'
    else
      puts "Добавлена станция в маршрут следования #{adding}"
      @routs[0].add_station(adding)
    end
  rescue RuntimeError => e
    puts e.message
  end

  def create_route
    raise 'Сначала необходимо создать 2 станции' if @stations.length < 2

    puts 'Для создания маршрута укажите начальную точку пути следования'
    point1 = $stdin.gets.chomp
    beginning = @stations.detect { |station| station.name == point1 }
    if beginning.nil?
      puts 'Такой станции нет в списке станций'
    else
      puts 'Добавлена начальная точка маршрута, теперь введите конечную станцию
      пути следования из списка созданных станций'
      point2 = $stdin.gets.chomp
      ending = @stations.detect { |station| station.name == point2 }
      if ending.nil?
        puts 'Такой станции нет в списке станций'
      else
        puts 'Добавлена конечная точка маршрута'
        @routs << Route.new(beginning, ending)
        puts "создан новый маршрут #{beginning.name}, #{ending.name}"
      end
    end
  rescue RuntimeError => e
    puts e.message
  end

  def add_train
    puts 'чтобы создать грузовой поезд, нажмите 1, чтобы создать пассажирский, нажмите 2'
    inp = $stdin.gets.chomp.to_i
    raise 'Поезд не создан! Можно создать, нажав клавишу 1 или 2!' unless [1, 2].include?(inp)

    case inp
    when 1
      puts 'Введите номер поезда(номером может быть сочетание цифр и букв формата ххх-хх)'
      number = $stdin.gets.chomp
      @trains << CargoTrain.new(number)
      puts "создан грузовой поезд #{number}"
    when 2
      puts 'Введите номер поезда(номером может быть сочетание цифр и букв формата ххх-хх)'
      number = $stdin.gets.chomp
      @trains << PassengerTrain.new(number)
      puts "создан пассажирский поезд #{number}"
    end
  rescue RuntimeError => e
    puts e.message
    retry
  end

  def add_station
    puts 'Введите название новой станции'
    name = $stdin.gets.chomp
    @stations << Station.new(name)
    puts "создана станция #{name}"
  rescue RuntimeError => e
    puts e.message
    retry
  end
end
c = Main.new
c.start
