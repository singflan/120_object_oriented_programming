class Person
  def initialize
    @secret = "Shh.. this is a secret!"
  end

  def secret
    @secret
  end

  def secret=(secret)
    @secret = secret
  end
end

person1 = Person.new
person1.secret = 'Shh.. this is a secret!'
puts person1.secret