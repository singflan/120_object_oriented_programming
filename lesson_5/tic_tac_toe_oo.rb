require 'pry'

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

  def initialize
    @squares = {}
    reset
  end

  def []=(num, marker)
    @squares[num].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  # returns winning marker or nil
  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  def find_at_risk_square(marker)
    # square = nil
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      # square = find_at_risk_square(squares, line, marker)
      # break if square
      # two_identical_markers?(squares)
      count = 0
      squares.each do |square|
        if square.marker == marker 
          count += 1
        end
      end

      if count(marker) == 2
        board.select{|k,v| line.include?(k) && v == ' '}.keys.first
      else
        nil
      end
    end
    # square
  end

  # def find_at_risk_square(squares, line, marker)
  #   if squares.values_at(*line).count(marker) == 2
  #     binding.pry
  #     board.select{|k,v| line.include?(k) && v == ' '}.keys.first
  #   else
  #     nil
  #   end
  # end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  # rubocop:disable Metrics/AbcSize
  def draw
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
  end
  # rubocop:enable Metrics/AbcSize

  private

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end

  def two_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 2
    markers.min == markers.max
  end

end

class Square
  INITIAL_MARKER = " "

  attr_accessor :marker

  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def marked?
    marker != INITIAL_MARKER
  end
end

class Player
  attr_reader :marker, :score, :name

  def initialize(marker)
    @marker = marker
  end

  def increase_score
    @score += 1
  end

  def reset_score
    @score = 0
  end
end

class TTTGame
  HUMAN_MARKER = 'X'
  COMPUTER_MARKER = 'O'
  FIRST_TO_MOVE = HUMAN_MARKER
  WINNING_SCORE = 5

  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
    @current_marker = FIRST_TO_MOVE
  end

  def play
    clear
    display_welcome_message

    loop do
      reset_scores
      loop do
        display_board

        loop do
          current_player_moves
          break if board.someone_won? || board.full?
          clear_screen_and_display_board
        end

        determine_winner_and_update_score
        display_result
        display_scoreboard
        break if winning_total_reached?
        # I want to change logic so board pauses so displayed results can be read
        ready_for_new_game?
        reset
      end

      display_game_winner_message
      break unless play_again?
      display_play_again_message
      reset
    end

    display_goodbye_message
  end

  private

  def display_welcome_message
    puts 'Welcome to Tic Tac Toe!'
    puts ''
  end

  def display_goodbye_message
    puts 'Thanks for playing Tic Tac Toe! Goodbye!'
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def display_board
    puts "You're a #{human.marker}. Computer is a #{computer.marker}."
    puts ''
    board.draw
    puts ''
  end

  def joinor(array, delimiter = ', ', joining_word = nil)
    new_string = ''
    array.each do |number|
      if number == array.last
        if array.size == 1
          new_string << "#{number}"
        else
          new_string << "#{joining_word} #{number}"
        end
      else
        new_string << "#{number}#{delimiter}" 
      end
    end
    new_string
  end

  def human_moves
    puts "Choose a square: #{joinor(board.unmarked_keys, ', ', 'and')}: "
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice."
    end

    board[square] = human.marker
  end

  def computer_moves
    square = nil
    square = board.find_at_risk_square(HUMAN_MARKER)
  
    if !square
      square = board.unmarked_keys.sample
    end
    binding.pry
    board[square] = computer.marker
  end

  def current_player_moves
    if @current_marker == HUMAN_MARKER
      human_moves
      @current_marker = COMPUTER_MARKER
    else
      computer_moves
      @current_marker = HUMAN_MARKER
    end
  end

  def determine_winner_and_update_score
    if board.winning_marker == COMPUTER_MARKER
      computer.increase_score
    elsif board.winning_marker == HUMAN_MARKER
      human.increase_score
    end
  end

  def display_result
    clear_screen_and_display_board

    case board.winning_marker
    when human.marker
      puts 'You won!'
    when computer.marker
      puts 'Computer won!'
    else
      puts "It's a tie!"
    end
  end

  def display_scoreboard
    puts "Human: #{human.score}, Computer: #{computer.score}"
  end

  def winning_total_reached?
    return true if human.score == WINNING_SCORE || computer.score == WINNING_SCORE
    false
  end

  def display_game_winner_message
    if human.score > computer.score
      puts "You reached #{WINNING_SCORE} first, you won the game!"
    elsif computer.score > human.score
      puts "The computer reached #{WINNING_SCORE} first, you lost the game!"
    end
  end

  def ready_for_new_game?
    answer = nil
    loop do
      puts "Are you ready for the next game? (Press 'y' when ready?)"
      answer = gets.chomp.downcase
      break if %w(y).include? answer
      puts 'Sorry, must be y'
    end

    answer == 'y'
  end

  def play_again?
    answer = nil
    loop do
      puts 'Would you like to play again? (y/n)'
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      puts 'Sorry, must be y or n'
    end

    answer == 'y'
  end

  def clear
    system 'clear'
  end

  def reset
    board.reset
    @current_marker = FIRST_TO_MOVE
    clear
  end

  def reset_scores
    human.reset_score
    computer.reset_score
  end

  def display_play_again_message
    puts "Let's play again!"
    puts ''
  end
end

game = TTTGame.new
game.play
