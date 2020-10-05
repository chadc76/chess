class Piece
  attr_reader :board, :color
  attr_accessor :pos
  def initialize(color, board, pos)
    @color, @board, @pos = color, board, pos
  end

  def to_s
   " #{symbol} "
  end

  def empty?
    false
  end

  def valid_moves

  end

  def symbol 
    raise NotImplementedError
  end

  private

  def move_into_check?(end_pos)
  end
end
