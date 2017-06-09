require 'pry'

class Board
  WINNING_LINES  = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

  def initialize
    # @squares = {1 => Square.new(' '), 2 => Square.new(' '), 3 => Square.new(' '), 
    #             4 => Square.new(' '), 5 => Square.new(' '), 6 => Square.new(' '), 
    #             7 => Square.new(' '), 8 => Square.new(' '), 9 => Square.new(' ') }
    @squares = {}
    reset
  end

  def []=(num, marker)
    @squares[num].marker = marker
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

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?(player1, player2)
    !!winning_marker(player1, player2)
  end

  # returns winning marker or nil
  def winning_marker(player1, player2)
    WINNING_LINES.each do |line|
      # if count_human_marker(@squares.values_at(*line)) == 3
      #   return TTTGame::HUMAN_MARKER
      # elsif count_computer_marker(@squares.values_at(*line)) == 3
      #   return TTTGame::COMPUTER_MARKER
      # end
      if count_markers(@squares.values_at(*line), player1) == 3
        return player1.marker
      elsif count_markers(@squares.values_at(*line), player2) == 3
        return player2.marker
      end
    end
    nil
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  private

  def count_markers(squares, player)
    squares.collect(&:marker).count(player.marker)
  end
end

class Square
  INITIAL_MARKER = ' '

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
end

class Player
  attr_reader :marker

  def initialize(marker)
    @marker = marker 
  end
end

class TTTGame 
  HUMAN_MARKER = 'X'
  COMPUTER_MARKER = 'O'
  FIRST_TO_MOVE = HUMAN_MARKER

  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
    @current_marker = FIRST_TO_MOVE
  end

  def play
    display_welcome_message

    loop do
      display_board

      loop do
        current_player_moves
        break if board.someone_won?(human, computer) || board.full?
        switch_current_player

        clear_screen_and_display_board
      end
      display_result
      break unless play_again?
      reset
      display_play_again_message
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

  def current_player_moves
    if @current_marker == HUMAN_MARKER
      puts "Choose a square between #{board.unmarked_keys.join(', ')}: "
      square = nil
      loop do
        square = gets.chomp.to_i
        break if board.unmarked_keys.include?(square)
        puts "Sorry, that's not a valid choice."
      end

      board[square] = human.marker
    elsif @current_marker == COMPUTER_MARKER
      board[board.unmarked_keys.sample] = computer.marker
    end
  end

  def display_result
    clear_screen_and_display_board

    case board.winning_marker(human, computer)
    when human.marker
      puts 'You won!'
    when computer.marker
      puts 'Computer won!'
    else
      puts "It's a tie!"
    end
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
    clear
  end

  def display_play_again_message
    puts "Let's play again!"
    puts ''
  end

  def switch_current_player
    if @current_marker == HUMAN_MARKER
      @current_marker = COMPUTER_MARKER
    elsif @current_marker == COMPUTER_MARKER
      @current_marker = HUMAN_MARKER
    end
  end
end

game = TTTGame.new
game.play
