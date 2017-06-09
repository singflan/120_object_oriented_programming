class Cat
  attr_reader :name
  @@num_of_cats = 0

  def initialize(name)
    @name = name
    @@num_of_cats += 1
  end

  def self.generic_greeting
    "Hello! I'm a cat!"
  end

  def personal_greeting
    "Hello! My name is #{name}"
  end

  def self.total
    @@num_of_cats
  end
end

kitty = Cat.new('Sophie')

Cat.generic_greeting
kitty.personal_greeting

kitty2 = Cat.new('Billy')

p Cat.total