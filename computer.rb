require_relative 'player'

class ComputerPlayer < Player

  def make_move(_board)      
    pieces = _board.pieces.select{|p| p.color == color && !p.valid_moves.empty?}
    piece = pieces.sample
    stat_pos = piece.pos 
    end_pos = piece.valid_moves.sample
    [stat_pos, end_pos]
  end
end