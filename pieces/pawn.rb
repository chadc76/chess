require_relative 'piece'

class Pawn < Piece

  def symbol
    '♟'.colorize(color)
  end

  def moves
    forward_steps + side_attacks
  end

  def upgrade?(color) 
    target = color == :white ? 0 : 7
    pos[0] == target 
  end

  private

  def at_start_row?
    row = color == :white ? 6 : 1
    pos[0] == row ? true : false
  end

  def forward_dir
    num = color == :white ? -1 : 1
    num
  end

  def forward_steps
    r, c = pos
    one_step = [r + forward_dir, c]
    return [] unless board.valid_pos?(one_step) && board.empty?(one_step)
    moves = [one_step]

    two_step = [r + 2 * forward_dir, c]
    moves << two_step if at_start_row? && board.empty?(two_step)
    moves
  end

  def side_attacks
    r, c = pos
    sides = [ [r + forward_dir, c - 1], [r + forward_dir, c + 1]]
    moves = []
    sides.select do |new_pos|
      next false unless board.valid_pos?(new_pos)
      next false if board.empty?(new_pos)

      threatened_piece = board[new_pos]
      threatened_piece && threatened_piece.color != color
    end
  end
end