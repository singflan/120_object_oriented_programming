class Minilang
  attr_accessor :register_value, :stack

  def initialize(string)
    @register_value = 0
    @string_array = string.split(' ')
    @stack = Array.new
  end

  def eval
    @string_array.each do |word|
      case word
      when 'PUSH' then stack.push(register_value)
      when 'ADD' then register_value += stack.pop
      when 'SUB' then register_value -= stack.pop
      when 'MULT' then register_value *= stack.pop
      when 'DIV' then register_value /= stack.pop
      when 'MOD' then register_value %= stack.pop
      when 'POP' then register_value = stack.pop
      when 'PRINT' then print register_value
      else
        register_value = word.to_i
      end
      p register_value
    end
  end
end


Minilang.new('PRINT').eval
# 0

Minilang.new('5 PUSH 3 MULT PRINT').eval
# 15

Minilang.new('5 PRINT PUSH 3 PRINT ADD PRINT').eval
# 5
# 3
# 8

Minilang.new('5 PUSH 10 PRINT POP PRINT').eval
# 10
# 5

Minilang.new('5 PUSH POP POP PRINT').eval
# Empty stack!

Minilang.new('3 PUSH PUSH 7 DIV MULT PRINT ').eval
# 6

Minilang.new('4 PUSH PUSH 7 MOD MULT PRINT ').eval
# 12

Minilang.new('-3 PUSH 5 XSUB PRINT').eval
# Invalid token: XSUB

Minilang.new('-3 PUSH 5 SUB PRINT').eval
# 8

Minilang.new('6 PUSH').eval
# (nothing printed; no PRINT commands)
