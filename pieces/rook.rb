require_relative "piece"
require_relative "slideable"

class Rook < Piece
  include Slideable

  def symbol
    '♜'.colorize(color)
  end

  protected
  
  def move_dir
    horizontal_and_vertical_dirs
  end
end