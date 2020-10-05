require_relative "piece"
class Board
  attr_reader :rows
  def initialize
      @rows = set_board
  end

  def [](pos)
    row, col = pos
    @rows[row][col]
  end

  def []=(pos, piece)
    row, col = pos
    @rows[row][col] = piece
  end

  def set_board
    new_board = Array.new(8){Array.new(8)}
    new_board.each_with_index do |_, row|
      _.each_with_index do |__, col|
        unless row.between?(2,5)
          new_board[row][col] = Piece.new
        end
      end
    end
    new_board
  end

  def move_piece(start_pos, end_pos)
    raise "There is no piece at #{start_pos}" if self[start_pos] == nil
    piece = self[start_pos]
    raise "You cannot move #{piece} to #{end_pos}" if self[end_pos] != nil
    self[start_pos] = nil
    self[end_pos] = piece
    rows
  end
end
