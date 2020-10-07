require_relative 'piece'
require_relative 'stepable'

class Knight < Piece
  include Stepable
  
  def symbol
    "N".colorize(color)
  end

  protected

  def move_diffs
    [[-2, -1],
     [-1, -2],
     [-2, 1],
     [-1, 2],
     [1, -2],
     [2, -1],
     [1, 2],
     [2, 1]]
  end
end