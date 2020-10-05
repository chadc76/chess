module Stepable
  def moves
    moves = []
    move_diffs.each do |dx, dy|
      cur_x, cur_y = pos
      cur_x, cur_y = cur_x + dx, cur_y + dy
      pos = [cur_x, cur_y]
      next unless board.valid_pos?(pos)
      if board[pos].empty?
        moves << pos
      elsif board[pos].color != self.color
        moves << color
      end
    end
    moves
  end

  private

  def move_diffs
    raise NotImplemnetedError
  end
end
