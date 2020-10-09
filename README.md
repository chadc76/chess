# Chess

  # Phase I: Board
  
    Your Board class should hold a 2-dimensional array (an array of arrays). Each position in the board either holds a moving Piece or a NullPiece (NullPiece will inherit from 
    Piece).

    There are many different kinds of pieces in chess, and each moves a specific way. Based on their moves, they can be placed in four categories:

    0. Sliding pieces (Bishop/Rook/Queen)
    1. Stepping pieces (Knight/King)
    2. Null pieces (occupy the 'empty' spaces)
    3. Pawns (we'll do this class last)

    To start off, you'll want to create an empty Piece class as a placeholder for now. Write code for #initialize so we can setup the board with instances of Piece in locations 
    where a Queen/Rook/Knight/ etc. will start and nil where the NullPiece will start.
    
    The Board class should have a #move_piece(start_pos, end_pos) method. This should update the 2D grid and also the moved piece's position. You'll want to raise an exception if:
    
    0. there is no piece at start_pos or
    1. the piece cannot move to end_pos.

    Time to test! Open up pry and load 'board.rb'. Create an instance of Board and check out different positions with board[pos]. Do you get back Piece instances where you expect 
    to? Test out Board#move_piece(start_pos, end_pos), does it raise an error when there is no piece at the start? Does it successfully update the Board?
    
    Once you get some of your pieces moving around the board, call over your TA for a code-review.

  # Phase II: Pieces

    Lets populate the Piece parent class that contains the functionality common to all pieces. A key method of Piece is #moves, which should return an array of places a Piece can 
    move to. Of course, every piece will move differently, so you can't write (implement) the #moves method of Piece without subclasses.
    
    NB You will not implement tricky moves like "en passant". Don't implement castling, draws, or pawn promotion either. You will handle check and check mate, however.
    
    You should make modules for Slideable and Stepable. The Slideable module can implement #moves, but it needs to know what directions a piece can move in (diagonal, 
    horizontally/vertically, both). Classes that include the module Slideable (Bishop/Rook/Queen) will need to implement a method #move_dirs, which #moves will use.
    
    Your Piece will need to (1) track its position and (2) hold a reference to the Board. Classes that include Slideable in particular need the Board so they know to stop sliding 
    when blocked by another piece. Don't allow a piece to move into a square already occupied by the same color piece, or to move a sliding piece past a piece that blocks it.
    
    The NullPiece class should include the singleton module. It will not need a reference to the Board - in fact its initialize method should take no arguments. Make sure you have 
    a way to read its color and symbol.
    
    Lastly, make your Pawn class. Be sure to use the Chess UML Diagram to guide you on what methods and instance variables to define for this class!
    
    After completing each piece load the file in pry and make sure it moves properly. Once you have completed all pieces refactor your Board#initialize so that all your pieces are 
    placed in their respective starting positions.
    
    Time to test! Open up pry and load 'board.rb'. Create an instance of Board and check out different positions with board[pos]. Do you get back instances of the type of pieces 
    you expect? Can you move the pieces around?
    
    For now, do not worry if a move leaves a player in check.

  # Phase III: Display

    Write a Display class to handle your rendering logic. Your Display class should access the board. Require the colorize gem so you can render in color.

    Download this cursor.rb file. An instance of Cursor initializes with a cursor_pos and an instance of Board. The cursor manages user input, according to which it updates its @cursor_pos. The display will render the square at @cursor_pos in a different color. Within display.rb require cursor.rb and set the instance variable @cursor to Cursor.new([0,0], board).

    NB: If you're stuck on making a cursor for more than 30 minutes, please call for help from a TA. Fancy cursors are cool, but the purpose of today is to become more familiar with Object-oriented Programming.

    In cursor.rb we've provided a KEYMAP that translates keypresses into actions and movements. The MOVES hash maps possible movement differentials. You can use the #get_input method as is. #read_char handles console input. Skim over #read_char to gain a general understanding of how the method works. It's all right if the STDIN methods are unfamiliar. Don't fret the details.

    Fill in the #handle_key(key) method. Use a case statement that switches on the value of key. Depending on the key, #handle_key(key) will a) return the @cursor_pos (in case of :return or :space), b) call #update_pos with the appropriate movement difference from MOVES and return nil (in case of :left, :right, :up, and :down), or c) exit from the terminal process (in case of :ctrl_c). Later we will use our Player and Game classes to handle the movement of pieces.

    NB: To exit a terminal process, use the Process.exit method. Pass it the status code 0 as an argument. You can read more about exit here.

    Fill in the #update_pos(diff) method. It should use the diff to reassign @cursor_pos to a new position. You may wish to write a Board#valid_pos? method to ensure you update @cursor_pos only when the new position is on the board.

    Render the square at the @cursor_pos display in a different color. Test that you can move your cursor around the board by creating and calling a method that loops through Display#render and Cursor#get_input (much as Player#make_move will function later!).

    A nice but optional addition to your cursor class is a boolean instance variable selected that will allow you to display the cursor in a different color when it has selected a piece. To implement this you will need to #toggle_selected everytime :return or :space is hit.

    Time to test! This time you should run ruby display.rb. Does your board render as you would expect? Make sure that as you move your cursor the display updates accordingly. Test the cursor's behavior when you try and move it off the board (the edge cases if you will). Does it do what you expect?

    Code Review Time: Before moving on to piece logic, get a code review from a TA!

  # Phase IV: Board#in_check?(color) and Board#checkmate?(color)

    The Board class should have a method #in_check?(color) that returns whether a player is in check. You can implement this by (1) finding the position of the King on the board then (2) seeing if any of the opposing pieces can move to that position.

    Then write a #checkmate?(color) method. If the player is in check, and if none of the player's pieces have any #valid_moves (to be implemented in a moment), then the player is in checkmate.

    NB Here's a four-move sequence to get to checkmate from a starting board for your checkmate testing:

     f2, f3
     e7, e5
     g2, g4
     d8, h4
