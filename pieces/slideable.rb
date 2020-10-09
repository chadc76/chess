module Slideable
  HORIZONTAL_AND_VERTICAL_DIRS = [
      [-1,0],
      [0,1],
      [0,-1],
      [1,0]
  ].freeze

  DIAGONAL_DIRS = [
      [-1,-1],
      [1,-1],
      [-1,1],
      [1,1]
  ].freeze

  def horizontal_and_vertical_dirs
    HORIZONTAL_AND_VERTICAL_DIRS
  end

  def diagonal_dirs
    DIAGONAL_DIRS
  end

  def moves
    moves = []
    move_dir.each do |dx, dy|
      moves.concat(grow_unblocked_moves_in_dir(dx, dy))
    end
    moves
  end

  private

  def move_dir
    raise NotImplementedError
  end

  def grow_unblocked_moves_in_dir(dx,dy)
    cur_x, cur_y = pos
    moves = []
    loop do
      cur_x, cur_y = cur_x + dx, cur_y + dy
      new_pos = [cur_x, cur_y]
      break unless board.valid_pos?(new_pos)

      if board[new_pos].empty?
        moves << new_pos
      elsif board[new_pos].color != self.color
        moves << new_pos
      else
        break
      end
    end
    moves       
  end
end
