module Moves

  attr_accessor :name, :bank, :score, :cards, :points, :deck, :stake

  def make_stake
    @bank -= @stake
  end     
  
  def points(deck)
    @points = 0
    @cards.each do |card|
     deck.each do |key, value| 
       if @points >= 11
        deck["ace♠"] = 1
        deck["ace♥"] = 1
        deck["ace♦"] = 1
        deck["ace♣"] = 1
       end 
       @points += value if card == key  
     end
    end 
    @points
  end
 
end