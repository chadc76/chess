class Board
  attr_reader :grid
  def initialize
      @grid = Array.new(8){Array.new(8)}
  end
end
