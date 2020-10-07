require_relative "pieces"
require 'colorize'
class Board
  attr_reader :rows
  def initialize(fill_board = true)
    @sentinel = NullPiece.instance
    make_starting_grid(fill_board)
  end

  def [](pos)
    row, col = pos
    @rows[row][col]
  end

  def []=(pos, piece)
    row, col = pos
    @rows[row][col] = piece
  end

  
  def move_piece(turn_color, start_pos, end_pos)
    raise "There is no piece at #{start_pos}" if empty?(start_pos)
    piece = self[start_pos]
    if piece.color != turn_color
      raise 'You must move your own piece'
    elsif !piece.moves.include?(end_pos)
      raise 'Piece does not move like that'
    end
    move_piece!(start_pos, end_pos)
    render
  end

  def move_piece!(start_pos, end_pos)
    piece = self[start_pos]
    raise 'Piece does not move like that' unless piece.moves.include?(end_pos)
    self[start_pos] = sentinel
    self[end_pos] = piece
    piece.pos = end_pos
    rows
  end

  def render
    copy = rows.dup
    new_rows = copy.map do |row|
      row.map do |piece|
        piece.symbol
      end
    end
    new_rows.each.with_index do |row, i|
      puts "#{i} #{row.join(" ")}".colorize(:background=>:blue)
    end
    nil
  end
  
  def val_pos?(pos)
    r, c = pos
    r.between?(0,7) && c.between?(0,7)
  end

  def add_piece(piece, pos)
    raise 'position not empty' unless empty?(pos)
    self[pos] = piece
  end
  

  def empty?(pos)
    self[pos].empty?
  end
  private

  attr_reader :sentinel

  def make_starting_grid(fill_board)
    @rows = Array.new(8) { Array.new(8, sentinel) }
    return unless fill_board
    %i(white black).each do |colors|
      fill_back_row(colors)
      fill_pawns_row(colors)
    end
    @rows
  end

  def fill_back_row(color)
    back_pieces = [
     Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook
    ]
    r = color == :white ? 7 : 0
    back_pieces.each_with_index do |piece, c|
      piece.new(color, self, [r, c])
    end
  end

  def fill_pawns_row(color)
    r = color == :white ? 6 : 1
    8.times {|c| piece = Pawn.new(color, self, [r, c]) }
  end
end
