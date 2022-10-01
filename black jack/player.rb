class Player
  
  include Moves
    
  def initialize(name)
    @name = name
    @bank = 100
    @cards = []
    @points = 0
    @stake = 10
  end 
  
end 