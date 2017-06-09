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
  attr_accessor :move, :name, :score, :move_history, :rule

  def initialize
    set_name
    @score = 0
    @move_history = []
    # @moves_count = {}
  end

  def get_move_count(moves)
    move_count = { 'rock' => 0, 'paper' => 0, 'scissors' => 0, 'lizard' => 0, 'spock' => 0 }
    moves.each do |round|
     round
      round.each do |move, result|
        move_count[move] += 1 if move 
      end
    end
    move_count
  end

  def get_move_percentage(moves)
    total = moves.size
    move_count = get_move_count(moves)
    move_percentage = move_count.map do |k, v|
       (v.to_f / total.to_f) 
    end
  end

  def get_win_total_and_count_per_move(moves)
    move_win_results = { 'rock' => [0, 0], 'paper' => [0, 0], 
                            'scissors' => [0, 0], 'lizard' => [0, 0], 'spock' => [0, 0] }
    moves.each do |round|
      round.each do |move, result|
        move_win_results[move][0] += 1 if move
        move_win_results[move][1] += 1 if result == :win
      end
    end
    move_win_results
  end

  def get_move_win_percentage_per_move(moves)
    # total = moves.size
    win_percentage_per_move_hash = { 'rock' => 0.0, 'paper' => 0.0, 'scissors' => 0.0, 'lizard' => 0.0, 'spock' => 0.0 }
    win_total_per_move = get_win_total_and_count_per_move(moves)
    win_total_per_move.each do |move, results|
      win_percentage_per_move_hash[move] = results[1].to_f / results[0].to_f
    end
    
    win_percentage_per_move_hash
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
    apply_rule
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
  def lower_10_percent_if_60_percent_lose(move_history)
    if 

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
    result = nil
    if human.move > computer.move
      human.score += 1
      human.move_history.push( {human.move.value => :win} )
      computer.move_history.push( {computer.move.value => :loss} )
    elsif human.move < computer.move
      computer.score += 1
      human.move_history.push( {human.move.value => :loss} )
      computer.move_history.push( {computer.move.value => :win} )
    else
      human.move_history.push( {human.move.value => :tie} )
      computer.move_history.push( {computer.move.value => :tie} )
    end    
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
    puts human.get_move_win_percentage_per_move(human.move_history)
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
