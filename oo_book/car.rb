module Towable
	def can_tow?(pounds)
		pounds < 2000 ? true: false
	end
end

class Vehicle
	@@num_of_vehicles = 0

	def self.num_of_vehicles
		puts "#{@@num_of_vehicles} have been created."
	end

	attr_accessor :color
	attr_reader :year, :model, :current_speed

	def initialize(y, c, m)
		@year = y
		@color = c
		@model = m
		@current_speed = 0
		@@num_of_vehicles += 1
	end

	def spray_paint(color)
		self.color = color
		puts "Your #{self.color} paint job looks great!"
	end

	def self.gas_mileage(gallons, miles)
		gas_mileage = miles / gallons
		puts "gas mileage is #{gas_mileage} miles per gallon"
	end

	def brake(amount)
		@current_speed -= amount
		puts "Slowing down by #{amount} miles per hour."
	end

	def speed_up(amount)
		@current_speed += amount
		puts "Speeding up by #{amount} miles per hour"
	end

	def turn_off
		self.current_speed = 0
		puts "Coming to a complete stop."
	end

	def age
		puts "Your #{self.model} is #{years_old} years old."
	end

	private
	def years_old
		Time.now.year - self.year
	end


end

class MyCar < Vehicle
	TOWING_POWER = 120

	def to_s
		"I am a #{self.year} #{self.color} #{@model}"
	end
end


class MyTruck < Vehicle
	include Towable
	TOWING_POWER = 300
end

maxima = MyCar.new(2009, "silver", "Maxima")
maxima.speed_up(20)
maxima.current_speed
maxima.speed_up(25)
maxima.current_speed
maxima.brake(21)
maxima.current_speed
maxima.color = 'yellow'
puts maxima.color
puts maxima.year
maxima.spray_paint('green')
puts maxima
puts MyCar.ancestors
puts MyTruck.ancestors
puts Vehicle.ancestors
maxima.age