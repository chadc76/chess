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

  # Phase V: Piece#valid_moves

    You will want a method on Piece that filters out the #moves of a Piece that would leave the player in check. A good approach is to write a Piece#move_into_check?(end_pos) method that will:

    0. Duplicate the Board and perform the move
    1. Look to see if the player is in check after the move (Board#in_check?)

    To do this, you'll have to write a Board#dup method. Your #dup method should duplicate not only the Board, but the pieces on the Board. Be aware: Ruby's #dup method does not call dup on the instance variables, so you may need to write your own Board#dup method that will dup the individual pieces as well.

    A note on deep duping your board

      As we saw when we recreated #dup using recursion, Ruby's native #dup method does not make a deep copy. This means that nested arrays and any arrays stored in instance variables will not be copied by the normal dup method:

      # Example: if piece position is stored as an array
      queen = Queen.new([0, 1])
      queen_copy = queen.dup
      
      # shouldn't modify original queen
      queen_copy.position[0] = "CHANGED"
      # but it does
      queen.position # => ["CHANGED", 1]

    Caution on duping pieces

      If your piece holds a reference to the original board, you will need to update this reference to the new duped board. Failure to do so will cause your duped board to generate incorrect moves!

    An alternative to duping?
    
      Another way to write #valid_moves would be to make the move on the original board, see if the player is in check, and then "undo" the move. However, this would require that Board have a method to undo moves.

      Once you write your Board#dup method, it'll be very straightforward to write Piece#valid_moves without complicated do/undo logic.

      It will likely help at this point to put some debug information into your Display class. Set a boolean variable on initialize of your Display for whether or not to show your debug info (you want to be able to easily turn this off). If that flag is set to true, then output some debug info, such as the selected piece's available moves, whether your opponent is in check, and so on.

      Test each piece's #valid moves! In pry load 'board.rb' and create a Board instance. Grab an instance of each type of piece (ie. from its position on the board) and check that calling #valid_moves returns what we expect. When you are satisfied it works call a TA over for a code review!

    Further Board improvements

      Modify your Board#move_piece method so that it only allows you to make valid moves. Because Board#move_piece needs to call Piece#valid_moves, #valid_moves must not call Board#move_piece. But #valid_moves needs to make a move on the duped board to see if a player is left in check. For this reason, write a method Board#move_piece!(start_pos, end_pos) which makes a move without checking if it is valid.

      Board#move_piece should raise an exception if it would leave you in check.

  # Phase VI: Game

    Only when done with the basic Chess logic (moving, check, checkmate) should you begin writing user interaction code.

    Write a Game class that constructs a Board object, then alternates between players (assume two human players for now) prompting them to move. The Game should handle exceptions from Board#move_piece and report them.

    You should write a HumanPlayer class with one method (#make_move). This method should call Cursor#get_input and appropriately handle the different responses (a cursor position or nil). In that case, Game#play method just continuously calls #make_move.

    It is not a requirement to write a ComputerPlayer, but you may do this as a bonus. If you write your Game class cleanly, it should be relatively straightforward to add new player types at a later date.

  # Phase VI: Bonus Round!

    After completing each phase of the project, please remember to go back and make your code truly stellar, practicing all you know about coding style, encapsulation, and exception handling.

    > DRY out your code
    > Use exception handling, and make sure to deal with bad user input
    > Method decomposition (pull chunks of code into helper methods)
    > Make helper methods private
    > Jazz up your User Interface (UI) with unicode.
    > Make a chess AI! Start with totally random moves. Next, capture pieces when possible. When you have this functionality working   start giving your pieces some strategy! You can do it!
