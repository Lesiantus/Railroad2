require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'wagon'
require_relative 'passenger_wagon'
require_relative 'cargo_wagon'
require_relative 'route'
require_relative 'station'

stations = []
trains =[]
routs = []
WAGON = {'cargo' => CargoWagon, 'passenger' => PassengerWagon}

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
  loop do
    puts "введите цифру, соответствующую желаемой операции"
    action = $stdin.gets.chomp.to_i
    break if action == 0

    if action == 1
      puts "Введите название новой станции"
      name = $stdin.gets.chomp
      stations << Station.new(name)
    elsif action == 2
      puts "Введите номер поезда(номером может любое сочетание цифр и букв)"
      number = $stdin.gets.chomp
      puts "чтобы создать грузовой поезд, нажмите 1, чтобы создать пассажирский, нажмите 2"
      inp = $stdin.gets.chomp.to_i
      if inp == 1
        trains << CargoTrain.new(number)
      elsif inp == 2
        trains << PassengerTrain.new(number)
      end
      p trains
    elsif action == 3
      puts "Для создания маршрута укажите начальную точку пути следования"
      point1 = $stdin.gets.chomp
      beginning = stations.detect{|station| station.name == point1}
        if beginning.nil?
          puts "Такой станции нет в списке станций"
        else
          puts "Добавлена начальная точка маршрута, теперь введите конечную станцию пути следования из списка созданных станций"
          point2 = $stdin.gets.chomp
          ending = stations.detect{|station| station.name == point2}
            if ending.nil?
              puts "Такой станции нет в списке станций"
            else
              puts "Добавлена конечная точка маршрута"
              routs << Route.new(beginning, ending)
            p beginning, ending, routs
            end
        end
    elsif action == 4
      puts "Введите название станции из списка созданных ранее"
      station_add = $stdin.gets.chomp
      adding = stations.detect{|station| station.name == station_add}
      if adding.nil?
        puts "такой станции еще нет в списке"
      else
        puts "Добавлена станция в маршрут следования"
        routs[0].add_station(adding)
        p routs[0]
      end
    elsif action == 5
      puts "Введите название станции из списка созданных ранее"
      station_delete = $stdin.gets.chomp
      deleting_station = routs[0].stations.detect{|station| station.name == station_delete}
      if deleting_station.nil?
        puts "такой станции еще нет в списке"
      else
        puts "Удалена станция из маршрута следования"
        routs[0].delete_station(deleting_station)
        p routs[0]
      end
    elsif action == 6
      puts "Введите номер поезда для присвоения маршрута"
      number = $stdin.gets.chomp
      train_number = trains.detect{|train| train.number == number}
      if train_number.nil?
        puts "Такого поезда еще нет в списке поездов"
      else train_number.add_route(routs[0])
        p train_number
      end
    elsif action == 7
      puts "Введите номер поезда для добавления вагона"
      number = $stdin.gets.chomp
      train_number = trains.detect{|train| train.number == number}
      if train_number.nil?
        puts "Такого поезда еще нет в списке поездов"
      else train_number.wagon_add(WAGON[train_number.type].new)
        p trains
      end
    elsif action == 8
      puts "Введите номер поезда для удаления вагона"
      number = $stdin.gets.chomp
      train_number = trains.detect{|train| train.number == number}
      if train_number.nil?
        puts "Такого поезда еще нет в списке поездов"
      elsif train_number.wagons.empty?
        puts "У этого поезда нет прицепленных вагонов"
      else train_number.wagon_remove(train_number.wagons.last)
        p trains
      end
    elsif action == 9
      puts "Выберите номер поезда"
      number = $stdin.gets.chomp
      train_number = trains.detect{|train| train.number == number}
      if train_number.nil?
        puts "Такого поезда еще не создано"
      elsif train_number.route.nil?
        puts "поезду еще не присвон маршрут"
      else
        puts "Введите станцию, на которую вы хотите отправить поезд"
        input = $stdin.gets.chomp
        station = stations.detect{|station| station.name == input}
        if train_number.route.stations.include?(station)
          train_number.next_station(station)
          puts "Поезд помещен на станцию #{station.name}"
        end
      end
    elsif action == 10
      stations.map{|el| puts el.name}
    elsif action == 11
      trains.map{|el| puts el.number}
    end
end




=begin train1 = CargoTrain.new("123cargo")
train2 = PassengerTrain.new("QPassenger")
wagon1 = CargoWagon.new
wagon2 = PassengerWagon.new

train1.wagon_add(wagon1)
train1.wagon_add(wagon2)
train2.wagon_add(wagon1)
train2.wagon_add(wagon2)

nsk = Station.new("Novosibirks")
krs = Station.new("Krsk")
fila = Station.new("Fila")

rt = Route.new(nsk, krs)
rt.show_stations
rt.add_station(fila)
rt.show_stations
rt.delete_station(fila)
rt.show_stations
nsk.arrival(train1)
nsk.trains_by_type("cargo")


puts train1.wagons
puts train2.wagons
=end
