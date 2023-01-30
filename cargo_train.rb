class CargoTrain<Train
  def initialize(number, type="cargo")
    super
  end

  def wagon_add(wagon)
    if wagon.type == "cargo"
      super(wagon)
    else
      puts "пассажирский вагон нельзя прицепить"
    end
  end
end
