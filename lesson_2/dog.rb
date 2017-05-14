class Animal

	def run
		'running!'
	end

	def jump
		'jumping!'
	end
end

class Dog < Animal
	def speak
		'bark!'
	end

	def swim
		'swimming!'
	end

	def fetch
		'fetching!'
	end
end

class Bulldog < Dog
	def swim
		"can't swim!"
	end
end

class Cat < Animal
	def speak
		'meow!'
	end
end

pete = Animal.new
kitty = Cat.new
dave = Dog.new
bud = Bulldog.new

puts pete.run
puts pete.speak

puts kitty.run
puts kitty.speak
puts kitty.fetch

puts dave.speak

puts bud.run
puts bud.swim