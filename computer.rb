require_relative 'player'

class ComputerPlayer < Player

  def make_move(_board)
    display.render
    if piece_threatened?(_board)
      move = piece_threatened?(_board)    
    elsif capture_piece(_board)
      move = capture_piece(_board)
    else
      move = random_move(_board)
    end
    move
  end

  private

  PIECE_VALUES = {
    Pawn => 1,
    Knight => 3, 
    Bishop => 3,
    Rook => 5,
    Queen => 9,
    King => 100
  }

  def pieces(_board)
    _board.pieces.select{|p| p.color == color && !p.valid_moves.empty?}
  end

  def capture_piece(_board)
    opponent_color = color == :white ? :black : :white
    threatening_moves = []
    pieces(_board).each do |piece|
      piece.valid_moves.each do |end_pos|
        threatening_moves << [piece.pos, end_pos] if _board[end_pos].color == opponent_color 
      end
    end
    threatening_moves.each do |move|
      stat_pos, end_pos = move
      piece1 = _board[stat_pos]
      piece2 = _board[end_pos]
      return move if calculate_move(piece1, piece2, _board) 
    end
    false
  end

  def random_move(_board)
    piece = pieces(_board).sample
    stat_pos = piece.pos 
    end_pos = piece.valid_moves.sample
    [stat_pos, end_pos]
  end

  def calculate_move(piece1, piece2, _board)
    if (PIECE_VALUES[piece2.class] - PIECE_VALUES[piece1.class]) < 0
      copy = _board.dup
      copy.move_piece!(piece1.pos, piece2.pos)
      opponent_color = piece2.color
      opponent_moves(opponent_color, copy).none?{|move| move == piece2.pos }
    else
      true
    end
  end

  def opponent_moves(opponent_color, _board)
    opponent_pieces = _board.pieces.select{|p| p.color == opponent_color}
    opponent_moves = []
    opponent_pieces.each do |piece|
      opponent_moves += piece.valid_moves
    end
    opponent_moves
  end

  def piece_threatened?(_board)
    strong_pieces = _board.pieces.select{|p| p.color == color && p.class != Pawn}
    opponent_color = color == :white ? :black : :white
    copy = _board.dup
    opponents = opponent_moves(opponent_color, copy)
    threatened = threatened_pieces(strong_pieces, opponents)
    return false if threatened.empty?
    move = value_moves(threatened, _board)
    return false if move.empty?
    move
  end

  def threatened_pieces(pieces, opponents)
    threatened_pieces = []
    pieces.each do |piece|
      threatened_pieces << piece if opponents.include?(piece.pos)
    end
    threatened_pieces
  end

  def value_moves(threatened_pieces, _board)
    start_pos = []
    value = 0
    threatened_pieces.each do |piece|
      new_value = PIECE_VALUES[piece.class]
      if new_value > value
        value = new_value
        start_pos = piece.pos
      end
    end
    [start_pos, _board[start_pos].valid_moves.sample]
  end
end