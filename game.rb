require_relative 'board'
require_relative 'display'
require_relative 'player'
require_relative 'human'
require_relative 'computer'

class Game
  attr_reader :board, :display, :players, :current_player
  def initialize(players = [false, true])
    @board = Board.new
    @display = Display.new(@board)
    @players = {}
    players.map.with_index do |is_computer, i|
      color = i == 0 ? :white : :black
      player = is_computer ? ComputerPlayer.new(color, @display) : HumanPlayer.new(color, @display)
      @players[color] = player
    end
    @current_player = :white
  end

  def play
    until board.checkmate?(current_player) || board.draw?(current_player)
      begin
      start_pos, end_pos = players[current_player].make_move(board)
      board.move_piece(current_player, start_pos, end_pos)
      board.upgrade(board[end_pos]) if board[end_pos].class == Pawn && board[end_pos].upgrade?(current_player)
      swap_turn!
      notify_players
      rescue StandardError => e
        @display.notifications[:error] = e.message
        retry
      end
    end

    display.render
    puts "#{current_player} is checkmated." if board.checkmate?(current_player)
    puts "Draw!" if board.draw?(current_player) && !board.checkmate?(current_player)
    nil
  end

  private

  def notify_players
    if board.in_check?(current_player)
      display.set_check!
    else
      display.uncheck!
    end
  end

  def swap_turn!
    @current_player = current_player == :white ? :black : :white
  end
end

if __FILE__ == $PROGRAM_NAME
  Game.new.play
end