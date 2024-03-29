require_relative 'player'
require_relative 'display'

class HumanPlayer < Player

  def make_move(_board)
    start_pos, end_pos = false, false
    until start_pos && end_pos
      @display.render
      if start_pos
        puts "#{color}'s turn. Move to where?"
        end_pos = display.cursor.get_input
        display.reset! if end_pos
      else
        puts "#{color}'s turn. Move from where?"
        start_pos = display.cursor.get_input
  
        display.reset! if start_pos
      end
    end
    [start_pos, end_pos]
  end
end