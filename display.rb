require 'colorize'
require_relative 'cursor'
require_relative 'board'

class Display
  attr_reader :board, :cursor
  def initialize(board)
    @board = board
    @cursor = Cursor.new([0,0], board)
  end

  def render
    system("clear")
    puts "Arrow keys, WASD, or vim to move, space or enter to confirm."
    build_grid.each { |row| puts row.join}
    nil
  end

  def build_grid
    @board.rows.map.with_index do |row, i|
      build_row(row, i)
    end
  end

  def build_row(row, i)
    row.map.with_index do |piece, j|
      colors = color_options(i, j)
      piece.to_s.colorize(colors)
    end
  end

  def color_options(i, j)
    if cursor.cursor_pos == [i,j] && cursor.selected
      bg = :light_green
    elsif cursor.cursor_pos == [i,j]
      bg = :red
    elsif (i + j).odd?
      bg = :light_blue
    else
      bg = :light_yellow
    end
    { background: bg }
  end

  def make_move
    turn_over = false
    until turn_over
      render
      cursor.get_input
    end
  end
end