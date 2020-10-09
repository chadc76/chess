require_relative "pieces"
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

  def empty?(pos)
    self[pos].empty?
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

  def valid_pos?(pos)
    r, c = pos
    r.between?(0,7) && c.between?(0,7)
  end

  def add_piece(piece, pos)
    raise 'position not empty' unless empty?(pos)
    self[pos] = piece
  end

  def checkmate?(color)
    checkmate = pieces.select(&:color).all? do |piece|
      piece.valid_moves.empty?
    end
    puts "Checkmate" if checkmate
    checkmate
  end

  def in_check?(color)
    king_pos = find_king(color)
    opposing_color = color == :white ? :black : :white
    check = check?(opposing_color, king_pos)
    puts "Check!" if check
    check
  end

  def find_king(color)
    pieces.each do |piece|
      return piece.pos if piece.is_a?(King) && piece.color == color
    end
  end

  def pieces
    @rows.flatten.reject(&:empty?)
  end

  def dup
    new_board = Board.new(false)

    pieces.each do |piece|
      piece.class.new(piece.color, new_board, piece.pos)
    end
    new_board
  end

  def move_piece!(start_pos, end_pos)
    piece = self[start_pos]
    raise 'Piece does not move like that' unless piece.moves.include?(end_pos)
    self[start_pos] = sentinel
    self[end_pos] = piece
    piece.pos = end_pos
    rows
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

  def check?(opposing_color, king_pos)
    self.pieces.each do |piece|
      return true if piece.color == opposing_color && piece.moves.include?(king_pos)
    end
    false
  end
end
