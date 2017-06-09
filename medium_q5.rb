class KrispyKreme
  def initialize(filling_type, glazing)
    if filling_type
      @filling_type = filling_type
    else
      @filling_type = "Plain"
    end
    @glazing = glazing
  end

  def to_s
    if @glazing
      puts "#{@filling_type} with #{@glazing}"
    else
      puts @filling_type
    end
  end
end

donut1 = KrispyKreme.new(nil, nil)
donut2 = KrispyKreme.new("Vanilla", nil)
donut3 = KrispyKreme.new(nil, "sugar")
donut4 = KrispyKreme.new(nil, "chocolate sprinkles")
donut5 = KrispyKreme.new("Custard", "icing")

puts donut1
puts donut2
puts donut3
puts donut4
puts donut5
