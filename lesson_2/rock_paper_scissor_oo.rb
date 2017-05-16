require 'pry'

WINNING_SCORE = 10

class Move
  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock']

  # def initialize(value)
  #   @value = value
  # end

  # def scissors?
  #   @value == 'scissors'
  # end

  # def rock?
  #   @value == 'rock'
  # end

  # def paper?
  #   @value == 'paper'
  # end

  # def lizard?
  #   @value == 'lizard'
  # end

  # def spock?
  #   @value == 'spock'
  # end
  attr_accessor :value

  # def >(other_move)
  #   (rock? && (other_move.scissors? || other_move.lizard?)) ||
  #     (paper? && (other_move.rock? || other_move.spock?)) ||
  #     (scissors? && (other_move.paper? || other_move.lizard?)) ||
  #     (lizard? && (other_move.spock? || other_move.paper?)) ||
  #     (spock? && (other_move.scissors? || other_move.rock?))  
  # end

  # def <(other_move)
  #   (rock? && (other_move.paper? || other_move.spock?)) ||
  #     (paper? && (other_move.scissors? || other_move.lizard?)) ||
  #     (scissors? && (other_move.rock? || other_move.spock?)) ||
  #     (lizard? && (other_move.rock? || other_move.scissors?)) ||
  #     (spock? && (other_move.lizard? || other_move.paper?))
  # end

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
  attr_accessor :move, :name, :score

  def initialize
    set_name
    @score = 0
  end

  def assign(choice)
    
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
      self.move == Spock.new
    end  
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
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
      self.move == Spock.new
    end    # case choice
    # when 'rock'
    #   self.move = Rock.new
    # when 'scissors'
    #   self.move = Scissors.new
    # when 'paper'
    #   self.move = Paper.new
    # when 'lizard'
    #   self.move = Lizard.new
    # when 'spock'
    #   self.move == Spock.new
    # end
  end
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
  end

  def display_score
    puts "Current Standings --> #{human.name}: #{human.score}, #{computer.name}: #{computer.score}"
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors, Lizard, Spock. Good bye!"
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
