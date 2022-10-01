class Dealer
  
  include Moves
  
  def initialize
    @name = :dealer
    @bank = 100
    @cards = []
    @points = 0
    @stake = 10
  end 
   
end 