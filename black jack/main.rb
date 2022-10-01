require_relative 'moves'
require_relative 'player'
require_relative 'dealer'

class Game

  attr_accessor :deck 
  
  def start
    puts "Как Вас зовут?"
    player = Player.new(gets.chomp)
    dealer = Dealer.new
    play(player, dealer)
  end

  def ask_for_game(player, dealer)
    puts "1 Сыграть заново"
    puts "2 Забрать деньги"
    if gets.chomp.to_i == 1
      play(player, dealer) 
    else
      :stop_game
    end 
  end  
  
  
  private

  def deck
    deck_points = [(1..10).to_a, 10, 10, 10, 11].flatten
    faces = [(1..10).to_a, :jack, :lady, :king, :ace].flatten 
    unsuited_deck = faces.zip(deck_points).to_h
    
    @deck = {}
    suits = ["♠", "♥", "♦", "♣"]
    suits.each do |suit|
      unsuited_deck.each do |key, value|
        @deck["#{key}#{suit}"] = value
      end 
    end 
    @deck 
  end

  def add_card(player_or_dealer)
    new_card = deck.keys.sample
    raise RuntimeError if player_or_dealer.cards.include?(new_card) 
    player_or_dealer.cards << new_card
    player_or_dealer.cards.flatten!
  rescue
    retry 
  end 
  
  def distribute_cards(player_or_dealer)
    add_card(player_or_dealer)
    add_card(player_or_dealer)
  end
  
  def play(player, dealer)
    player.cards = []
    dealer.cards = []
    distribute_cards(dealer)
    distribute_cards(player)
    puts "Ваши карты: #{player.cards}. Ваши очки: #{player.points(deck)}"
    dealer.points(deck)
    puts "Карты крупье: #{"*" * dealer.cards.count}"

    
    make_stake(player, dealer) 
    puts "Сделаны ставки по 10 долларов"
    puts "В Вашем банке #{player.bank} долларов"  
    puts "В банке крупье #{dealer.bank} долларов" 
    loop do
      player_move(player, dealer)
      results(player, dealer)
      break if :stop_game 
    end 
  end 

  def open(player, dealer)
    puts "Игра окончена"
    puts "Ваши карты #{player.cards}, очки #{player.points(deck)}"
    puts "Карты крупье #{dealer.cards}, очки #{dealer.points(deck)}"
  end 

  def player_move(player, dealer) 
    puts "#{player.name}, выберите ход:"
    puts "1. Пропустить"
    puts "2. Добавить карту"
    puts "3. Открыть карты"
    choice = gets.chomp.to_i 
    case choice
    when 1 
      puts "Вы передали ход крупье"
      dealer_move(player, dealer)
    when 2  
      player_add_card(player, dealer) 
    when 3 then open(player, dealer)
    end  
  rescue RuntimeError =>e
    puts e.message 
    retry 
  end 

  def three_cards?(player, dealer)
    player.cards.count == 3 && dealer.cards.count == 3
  end 

  def twenty_one?(player, dealer)
    player.points(deck) > 21 || dealer.points(deck) > 21
  end
  
  def results(player, dealer)
    puts "Результаты игры:"
    ending_point = 21
    array = [ player.points(deck), dealer.points(deck) ]
    closest_point = array.min_by{ |x| (ending_point - x).abs }
    
    if player.points(deck) == dealer.points(deck)
      call_even(player, dealer)
    elsif player.points(deck) <= 21 && dealer.points(deck) > 21  
      call_winner(player, dealer)
    elsif dealer.points(deck) <= 21 && player.points(deck) > 21  
      call_winner(dealer, player)
    else
      if dealer.points(deck) == closest_point
        call_winner(dealer, player)
      elsif player.points(deck) == closest_point
        call_winner(player, dealer)
      end 
    end
    ask_for_game(player, dealer)
  end

  def make_stake(player, dealer)
    player.make_stake
    dealer.make_stake
  end 

  def player_add_card(player, dealer)
    raise "У Вас уже три карты, Вы не можете добавить больше" if player.cards.count >= 3 
    add_card(player)
    puts "Вы добавили карту. Ваши карты #{player.cards}. Ваши очки #{player.points(deck)}" 
    if three_cards?(player, dealer) ||  twenty_one?(player, dealer)  
      open(player, dealer) 
    else 
      puts "Ход переходит крупье"
      dealer_move(player, dealer)
    end 
  end
  
  def dealer_move(player, dealer)
    if dealer.points(deck) >= 17 
      puts "Крупье пропустил ход"
      player_move(player, dealer)
    elsif dealer.points(deck) < 17 && dealer.cards.count < 3
      add_card(dealer)
      puts "Крупье добавил карту. Карты крупье #{"*" * dealer.cards.count}"
      if three_cards?(player, dealer) || twenty_one?(player, dealer)
        open(player, dealer)
      else  
        player_move(player, dealer)
      end 
    end 
  end

  def call_even(player, dealer)
    puts player.bank +=10
    puts dealer.bank +=10
    puts "Ничья. Деньги возвращаются в банки"
    puts "Банк игрока #{player.bank}"
    puts "Банк дилера #{dealer.bank}" 
    
  end 

  def call_winner(winner, loser)
    puts "Выиграл #{winner.name}"
    reward = loser.stake + winner.stake 
    puts "#{reward} долларов(-а) передано в банк #{winner.name}"
    winner.bank += reward
    puts "В банке #{winner.name} #{winner.bank} долларов"
    puts "В банке #{loser.name} #{loser.bank} долларов"
  end 
  
end 

Game.new.start
