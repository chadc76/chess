require_relative 'player'

class ComputerPlayer < Player

  def make_move(_board)
    display.render
    if checkmate_possible(_board)
      move = checkmate_possible(_board)
    elsif piece_threatened?(_board)
      move = piece_threatened?(_board)    
    elsif capture_piece(_board)
      move = capture_piece(_board)
    elsif safe_check(_board) && in_endgame?(_board)
      move = safe_check(_board)
    elsif check_possible(_board) && in_endgame?(_board)
      move = check_possible(_board)
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
    piece = pieces(_board).reject{|p| p.valid_moves.empty?}.sample
    [piece.pos, piece.valid_moves.sample]
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
    move = safe_move(_board[start_pos], _board)
    move
  end

  def safe_move(piece, _board)
    piece.valid_moves.each do |end_pos|
      copy = _board.dup
      copy.move_piece!(piece.pos, end_pos)
      return [piece.pos, end_pos] if opponent_moves(opponent_color, copy).none?{|move| move == end_pos}
    end
    return []
  end

  def safe_check(_board)
    pieces(_board).each do |piece|
      piece.valid_moves.each do |end_pos|
      copy = _board.dup
      copy.move_piece!(piece.pos, end_pos)
      return [piece.pos, end_pos] if copy.in_check?(opponent_color) && opponent_moves(opponent_color, copy).none?{|move| move == end_pos}
      end
    end
    false
  end

  def opponent_color
    opponent_color = color == :white ? :black : :white
  end

  def checkmate_possible(_board)
    pieces(_board).each do |piece|
      piece.valid_moves.each do |move|
      copy = _board.dup
      copy.move_piece!(piece.pos, move)
      return [piece.pos, move] if copy.checkmate?(opponent_color)
      end
    end
    false
  end

  def check_possible(_board)
    pieces(_board).each do |piece|
      piece.valid_moves.each do |end_pos|
      copy = _board.dup
      copy.move_piece!(piece.pos, end_pos)
      return [piece.pos, end_pos] if copy.in_check?(opponent_color)
      end
    end
    false
  end

  def in_endgame?(_board)
    strong_pieces = _board.pieces.select{|p| p.color == opponent_color && p.class != Pawn}
    strong_pieces.none?{|p| p.class == Queen} && strong_pieces.count <= 4
  end
end