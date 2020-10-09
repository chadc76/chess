class Piece
  attr_reader :board, :color, :moves
  attr_accessor :pos
  def initialize(color, board, pos)
    @color, @board, @pos = color, board, pos

    board.add_piece(self, pos)
  end

  def to_s
   " #{symbol} "
  end

  def empty?
    false
  end

  def valid_moves
    moves.reject{|move| move_into_check?(move)}
  end

  def symbol 
    raise NotImplementedError
  end

  private

  def move_into_check?(end_pos)
    copy = board.dup
    copy.move_piece!(pos, end_pos)
    copy.in_check?(color)
  end
end
