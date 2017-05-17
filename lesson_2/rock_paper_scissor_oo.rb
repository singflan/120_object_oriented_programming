require 'pry'

WINNING_SCORE = 10

class Move
  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock']

  attr_accessor :value

  def to_s
    @value
  end
end

class Rock < Move 
  def initialize 
    @value = 'rock'
  end

  def >(other_move)
    other_move.class == Scissors || other_move.class == Lizard
  end

  def <(other_move)
    other_move.class == Paper || other_move.class == Spock
  end
end

class Scissors < Move 
  def initialize 
    @value = 'scissors'
  end

  def >(other_move)
    other_move.class == Paper || other_move.class == Lizard
  end

  def <(other_move)
    other_move.class == Rock || other_move.class == Spock
  end
end

class Paper < Move 
  def initialize 
    @value = 'paper'
  end

  def >(other_move)
    other_move.class == Rock || other_move.class == Spock
  end

  def <(other_move)
    other_move.class == Lizard || other_move.class == Scissors
  end
end

class Lizard < Move 
  def initialize 
    @value = 'lizard'
  end

  def >(other_move)
    other_move.class == Spock || other_move.class == Paper
  end

  def <(other_move)
    other_move.class == Rock || other_move.class == Scissors
  end
end

class Spock < Move 
  def initialize 
    @value = 'spock'
  end

  def >(other_move)
    other_move.class == Scissors || other_move.class == Rock
  end

  def <(other_move)
    other_move.class == Paper || other_move.class == Lizard
  end
end

class Player
  attr_accessor :move, :name, :score, :move_history

  def initialize
    set_name
    @score = 0
    @move_history = {}
    # @moves_count = {}
  end

  def get_move_percentage(moves)
    total = moves.size
    moves_count = { rock: moves.count('rock'), paper: moves.count('paper'), 
                    scissors: moves.count('scissors'), lizard: moves.count('lizard'), 
                    spock: moves.count('spock') 
                  }
    moves_percentage = moves_count.map do |k, v|
       (v.to_f / total.to_f) 
    end
    # moves_percentage
  end
end

class Human < Player
  def set_name
    n = nil
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, must enter a value."
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts "Please choose rock, paper, scissors, lizard, or spock: "
      choice = gets.chomp
      break if Move::VALUES.include? choice
      puts "Sorry, invalid choice."
    end
    #self.move = Move.new(choice)
    case choice
    when 'rock'
      self.move = Rock.new
    when 'scissors'
      self.move = Scissors.new
    when 'paper'
      self.move = Paper.new
    when 'lizard'
      self.move = Lizard.new
    when 'spock'
      self.move = Spock.new
    end  
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end

  def apply_rule

  end

  def choose
    #self.move = Move.new(Move::VALUES.sample)
    choice = Move::VALUES.sample
    case choice
    when 'rock'
      self.move = Rock.new
    when 'scissors'
      self.move = Scissors.new
    when 'paper'
      self.move = Paper.new
    when 'lizard'
      self.move = Lizard.new
    when 'spock'
      self.move = Spock.new
    end   
  end
end

class Rule

end

class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors, Lizard, Spock!"
  end

  def display_moves
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}"
  end

  def display_winner
    if human.move > computer.move
      puts "#{human.name} won!"
    elsif human.move < computer.move
      puts "#{computer.name} won!"
    else
      puts "It's a tie!"
    end
  end

  def update_score
    if human.move > computer.move
      human.score += 1
    elsif human.move < computer.move
      computer.score += 1
    end

    human.move_history.push(human.move.value)
    computer.move_history.push(computer.move.value)
  end

  def display_score
    puts "Current Standings --> #{human.name}: #{human.score}, #{computer.name}: #{computer.score}"
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors, Lizard, Spock. Good bye!"
  end

  def view_moves?
    answer = nil
    loop do
      puts "Would you like to view each player's move history? (y/n)"
      answer = gets.chomp.downcase
      break if ['y', 'n'].include? answer
      puts "Sorry, must be y or no."
    end

    if answer == 'y'
      puts "#{human.name}'s moves: #{human.move_history}"
      puts "#{computer.name}'s moves: #{computer.move_history}"
      puts "#{human.get_move_percentage(human.move_history)} #{computer.get_move_percentage(computer.move_history)}"
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include? answer.downcase
      puts "Sorry, must be y or no."
    end

    return false if answer.downcase == 'n'
    return true if answer.downcase == 'y'
  end

  def play
    display_welcome_message
    loop do
      loop do 
        human.choose
        computer.choose
        display_moves
        update_score
        display_winner
        display_score
        view_moves?
        break if human.score == WINNING_SCORE || computer.score == WINNING_SCORE
      end
      break unless play_again?
      human.score = 0
      computer.score = 0
    end
    display_goodbye_message
  end
end

RPSGame.new.play
