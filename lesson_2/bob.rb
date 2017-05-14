
class Person

	attr_accessor :first_name, :last_name
	 
	def initialize(n)
		parse_full_name(n)
	end

	def name
		@name = "#{first_name} #{last_name}".strip
	end

	def name=(name)
			parse_full_name(name)
	end

	def to_s
		name
	end

	private
	def parse_full_name(full_name)
		parts = full_name.split
		@first_name = parts.first
		@last_name = parts.size > 1 ? parts.last : ''
	end
end

bob = Person.new('Robert')
puts bob.name
puts bob.first_name
puts bob.last_name
puts bob.last_name = 'Smith'
puts bob.name

puts bob.name = 'John Adams'
puts bob.first_name
puts bob.last_name
bob  = Person.new('Robert Smith')
rob = Person.new('Robert Smith')
puts bob.name == rob.name
puts "The person's name is: #{bob}"