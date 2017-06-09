class Cat
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def rename(new_name)
    self.name = new_name
  end

  def identify
    self
  end
end

kitty = Cat.new('Sophie')
p kitty.name
p kitty.identify
kitty.rename('Chloe')
p kitty.name
