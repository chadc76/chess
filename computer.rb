require_relative 'player'

class ComputerPlayer < Player

  def make_move(_board)    
    if capture_piece(_board)
      move = capture_piece(_board)
    else
      move = random_move(_board)
    end
    move
  end

  private

  PIECE_VALUES = {
    Pawn => 0,
    Knight => 1, 
    Rook => 2,
    Bishop => 2,
    Queen => 3,
  }

  def pieces(_board)
    _board.pieces.select{|p| p.color == color && !p.valid_moves.empty?}
  end

  def capture_piece(_board)
    opponent_color = color == :white ? :black : :white
    threatening_moves = []
    pieces(_board).each do |piece|
      piece.moves.each do |end_pos|
        threatening_moves << [piece.pos, end_pos] if _board[end_pos].color == opponent_color 
      end
    end
    next_move = []
    value = -1
    threatening_moves.each do |move|
      stat_pos, end_pos = move
      if PIECE_VALUES[_board[end_pos].class] > value
        next_move = move
        value = PIECE_VALUES[_board[end_pos].class]
      end
    end
    return next_move if !next_move.empty?
    false
  end

  def random_move(_board)
    piece = pieces(_board).sample
    stat_pos = piece.pos 
    end_pos = piece.valid_moves.sample
    [stat_pos, end_pos]
  end
  
end