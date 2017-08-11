class Participant
  attr_reader :hand
  attr_accessor :name, :hand_total
  # what goes in here? all the redundant behaviors from Player and Dealer?
  def initialize(name = nil)
    @hand = []
    @hand_total = 0
    @name = name
  end

  def calc_value_hand
    num_of_aces = 0
    value = 0
    hand.each do |card|
      p card.face
      p card.calc_card_value

      # face_value = card[1]
      # case card.face
      # when 'J', 'Q', 'K'
      #   value = 10
      # when '2', '3', '4', '5', '6', '7', '8', '9', '10'
      #   value = face_value.to_i 
      # when 'A'
      #   if @hand_total + 11 <= 21
      #     value = 11
      #   else
      #     value = 1
      #   end
      #   num_of_aces += 1
      # end
      # @hand_total += value
    end
    @hand_total
  end

  def display_hand_value
    puts "#{name} has a hand total of #{hand_total} points"
  end
end

class Player < Participant
  # def initialize
  #   # what would the "data" or "states" of a Player object entail?
  #   # maybe cards? a name?   
  # end

  def hit

  end

  def stay
  end

  def busted?
  end

  def total
    # definitely looks like we need to know about "cards" to produce some total
  end
end

class Dealer < Participant
  POSSIBLE_NAMES = ["Billy", "R2-D2", "Ex-Hacker", "Sam I Am"]
  
  def initialize
    # seems like very similar to Player... do we even need this?
    super
    @name = POSSIBLE_NAMES.sample  
  end

  def deal
    # does the dealer or the deck deal?
  end

  def hit
  end

  def stay
  end

  def busted?
  end

  def total
  end
end

# module Hand
#   @cards = []
# end

class Deck
  attr_reader :cards

  def initialize
    @cards = []
    Card::SUITS.each do |suit|
      Card::FACES.each do |face|
        @cards << Card.new(suit, face)
      end
    end

    shuffle_deck!
  end

  def shuffle_deck!
    cards.shuffle!
  end

  def deal
    # does the dealer or the deck deal?
    cards.pop
  end
end

class Card
  SUITS = ['H', 'A', 'D', 'S']
  FACES = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']
  
  # attr_accessor :value
  # attr_reader :suit, :face
  def initialize(suit, face)
    @suit = suit
    @face = face
  end

  def to_s
    "The #{face} of #{suit}"
  end

  def face
    case @face
    when 'J' then 'Jack'
    when 'Q' then 'Queen'
    when 'K' then 'King'
    when 'A' then 'Ace'
    else
      @face
    end
  end

  def suit
    case @suit
    when 'H' then 'Hearts'
    when 'D' then 'Diamonds'
    when 'S' then 'Spades'
    when 'C' then 'Clubs'
    end
  end

  def ace?
    face == 'Ace'
  end

  def king?
    face == 'King'
  end

  def queen?
    face == 'Queen'
  end

  def jack?
    face == 'Jack'
  end

  def calc_card_value(num_of_aces = 0)
    case face
      when 'J', 'Q', 'K'
        value = 10
      when '2', '3', '4', '5', '6', '7', '8', '9', '10'
        value = face.to_i 
      when 'A'
        if @hand_total + 11 <= 21
          value = 11
        else
          value = 1
        end
        num_of_aces += 1
      end
  end
end

class Game
  attr_reader :deck, :player, :dealer

  def initialize
    @deck = Deck.new
    @player = Player.new("Nick")
    @dealer = Dealer.new
    puts "Game initialized"
  end

  def reset
    self.deck = Deck.new
    player.hand = []
    player.hand_total = 0
    dealer.hand = []
    dealer.hand_total = 0
  end

  def start
    # what's the sequence of steps to execute the game play?
    deal_cards
    show_initial_cards
    player_turn
    dealer_turn
    show_result
  end

  def deal_cards
    2.times do 
      player.hand << deck.deal
      dealer.hand << deck.deal
    end
  end

  def draw(person)
    person.hand << deck.deal
  end

  # def calculate_points(person)

  # end

  def show_initial_cards
    puts "Player's hand: #{player.hand}, Dealer's hand: #{dealer.hand}"
  end

  def player_turn
    # choose to draw or stay
    player.calc_value_hand
    player.display_hand_value
    loop do 
      response = ask_player_draw_or_stay
      break if response == 's'
      draw(player)
      # p player.hand

      player.calc_value_hand
      player.display_hand_value
      if player.hand_total > 21
        puts "#{player.name} loses & #{dealer.name} wins!"
        break
      end
    end
  end

  def dealer_turn
    dealer.calc_value_hand
    dealer.display_hand_value
    draw(dealer)
  end

  def ask_player_draw_or_stay
    answer = nil
    loop do
      puts "Would you like to draw or stay (enter 'd' or 's')?"
      answer = gets.chomp.downcase
      break if %w(d s).include? answer
      puts 'Sorry, must be d or s'
    end
    answer
  end

  def show_result

  end
end


game = Game.new
game.start