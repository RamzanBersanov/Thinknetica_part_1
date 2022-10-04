module Moves

  attr_accessor :name, :bank, :score, :cards, :points, :deck, :stake

  def make_stake
    @bank -= @stake
  end     
  
  def points(deck)
    @points = 0
    @cards.each do |card|
      deck.each do |key, value| 
        @points += value if card == key
      end 
    end 
    ace_points
    @points
  end

  def ace_points
    @cards.each do |card|
      if card.include?("ace")
        if @points >= 11
          @points += 1
        elsif @points < 11
          @points += 11
        end 
      end 
    end 
    @points 
  end 
 
end
