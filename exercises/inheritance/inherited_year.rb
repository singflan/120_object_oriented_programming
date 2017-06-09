class Vehicle
  attr_reader :year

  def initialize(year)
    @year = year
  end
end

class Truck < Vehicle
  def initialize
    super
    start_engine
  end

  def start_engine
    puts 'Ready to go!'
  end
end

class Car < Vehicle
end

truck1 = Truck.new(1994)
puts truck1.year

# car1 = Car.new(2006)
# puts car1.year