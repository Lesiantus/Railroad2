class PassengerTrain<Train
  def initialize(number, type="passenger")
    super
  end

  def wagon_add(wagon)
    if wagon.type == "passenger"
      super(wagon)
    else
      puts "грузовой вагон нельзя прицепить"
    end
  end
end
