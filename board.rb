require_relative "piece"
class Board
  attr_reader :grid
  def initialize
      @grid = set_board
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
    r1,c1 = start_pos
    r2,c2 = end_pos
    raise "There is no piece at #{start_pos}" if grid[r1][c1] == nil
    piece = grid[r1][c1]
    raise "You cannot move #{piece} to #{end_pos}" if grid[r2][c2] != nil
    grid[r1][c1] = nil
    grid[r2][c2] = piece
    grid
  end
end
