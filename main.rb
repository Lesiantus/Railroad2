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
  WAGON = {:cargo => CargoWagon, :passenger => PassengerWagon}
  def initialize
    @stations = []
    @trains =[]
    @routs = []
  end

  def start
    loop do
      show_menu
      choice = get_choice
      action(choice)
      if choice == 0
        break
      end
    end
  end

  def show_menu
    puts %Q(
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
    0 Выход
    )
  end
  def get_choice
    puts "Введите номер операции"
    @choice = $stdin.gets.chomp.to_i
  end

  def action(choice)
    if @choice == 1
      add_station
    elsif @choice == 2
      add_train
    elsif @choice == 3
      create_route
    elsif @choice == 4
      route_station_add
    elsif @choice == 5
      route_station_delete
    elsif @choice == 6
      add_route_to_train
    elsif @choice == 7
      add_wagon_to_train
    elsif @choice == 8
      delete_wagon_from_train
    elsif @choice == 9
      move_train
    elsif @choice == 10
      stations_list
    elsif @choice == 11
      trains_list
    end
  end


  def trains_list
    @trains.map{|el| puts el.number}
  end


  def stations_list
    @stations.map{|el| puts el.name}
  end


  def move_train
    puts "Выберите номер поезда"
    number = $stdin.gets.chomp
    train_number = @trains.detect{|train| train.number == number}
    if train_number.nil?
      puts "Такого поезда еще не создано"
    elsif train_number.route.nil?
      puts "поезду еще не присвон маршрут"
    else
      puts "Введите станцию, на которую вы хотите отправить поезд"
      input = $stdin.gets.chomp
      station = @stations.detect{|station| station.name == input}
      if train_number.route.stations.include?(station)
        train_number.next_station(station)
        puts "Поезд помещен на станцию #{station.name}"
      end
    end
  end


  def delete_wagon_from_train
    puts "Введите номер поезда для удаления вагона"
    number = $stdin.gets.chomp
    train_number = @trains.detect{|train| train.number == number}
    if train_number.nil?
      puts "Такого поезда еще нет в списке поездов"
    elsif train_number.wagons.empty?
      puts "У этого поезда нет прицепленных вагонов"
    else train_number.wagon_remove(train_number.wagons.last)
      puts "поузду номер #{number} был отцеплен вагон"
    end
  end


  def add_wagon_to_train
    puts "Введите номер поезда для добавления вагона"
    number = $stdin.gets.chomp
    train_number = @trains.detect{|train| train.number == number}
    if train_number.nil?
      puts "Такого поезда еще нет в списке поездов"
    else train_number.add_wagon(WAGON[train_number.type].new)
      puts "поезду номер #{number} был добавлен вагон"
    end
  end


  def add_route_to_train
    puts "Введите номер поезда для присвоения маршрута"
    number = $stdin.gets.chomp
    train_number = @trains.detect{|train| train.number == number}
    if train_number.nil?
      puts "Такого поезда еще нет в списке поездов"
    else train_number.add_route(@routs[0])
      puts "Поезду #{number} был назначен маршрут"
    end
  end

  def route_station_delete
    puts "Введите название станции из списка созданных ранее"
    station_delete = $stdin.gets.chomp
    deleting_station = @routs[0].stations.detect{|station| station.name == station_delete}
    if deleting_station.nil?
      puts "такой станции еще нет в списке"
    else
      puts "Удалена станция из маршрута следования #{deleting_station}"
      @routs[0].delete_station(deleting_station)
    end
  end


  def route_station_add
    puts "Введите название станции из списка созданных ранее"
    station_add = $stdin.gets.chomp
    adding = @stations.detect{|station| station.name == station_add}
    if adding.nil?
      puts "такой станции еще нет в списке"
    else
      puts "Добавлена станция в маршрут следования #{adding}"
      @routs[0].add_station(adding)
    end
  end


  def create_route
    puts "Для создания маршрута укажите начальную точку пути следования"
    point1 = $stdin.gets.chomp
    beginning = @stations.detect{|station| station.name == point1}
    if beginning.nil?
      puts "Такой станции нет в списке станций"
    else
      puts "Добавлена начальная точка маршрута, теперь введите конечную станцию пути следования из списка созданных станций"
      point2 = $stdin.gets.chomp
      ending = @stations.detect{|station| station.name == point2}
      if ending.nil?
        puts "Такой станции нет в списке станций"
      else
        puts "Добавлена конечная точка маршрута"
        @routs << Route.new(beginning, ending)
        puts "создан новый маршрут #{beginning.name}, #{ending.name}"
      end
    end
  end


  def add_train
    puts "чтобы создать грузовой поезд, нажмите 1, чтобы создать пассажирский, нажмите 2"
    inp = $stdin.gets.chomp.to_i
    if inp == 1
      puts "Введите номер поезда(номером может быть сочетание цифр и букв формата ххх-хх)"
      number = $stdin.gets.chomp
      @trains << CargoTrain.new(number)
      puts "создан грузовой поезд #{number}"
    elsif inp == 2
      puts "Введите номер поезда(номером может быть сочетание цифр и букв формата ххх-хх)"
      number = $stdin.gets.chomp
      @trains << PassengerTrain.new(number)
      puts "создан пассажирский поезд #{number}"
    end
  rescue RuntimeError => e
    puts e.message
    retry
  end

  def add_station
    puts "Введите название новой станции"
    name = $stdin.gets.chomp
    @stations << Station.new(name)
    puts "создана станция #{name}"
  rescue RuntimeError => e
    puts e.message
    retry
  end
end
c=Main.new
c.start
