# University of Washington, Programming Languages, Homework 6, hw6runner.rb

# This is the only file you turn in, so do not modify the other files as
# part of your solution.
class MyPiece < Piece
	@@cheated = false
   All_My_Pieces = [[[[0, 0], [1, 0], [0, 1], [1, 1]]],  # square (only needs one)
               rotations([[0, 0], [-1, 0], [1, 0], [0, -1]]), # T
               [[[0, 0], [-1, 0], [1, 0], [2, 0]], # long (only needs two)
               [[0, 0], [0, -1], [0, 1], [0, 2]]],
               rotations([[0, 0], [0, -1], [0, 1], [1, 1]]), # L
               rotations([[0, 0], [0, -1], [0, 1], [-1, 1]]), # inverted L
               rotations([[0, 0], [-1, 0], [0, -1], [1, -1]]), # S
               rotations([[0, 0], [1, 0], [0, -1], [-1, -1]]),# Z
			   rotations([[0, 0], [0, -1], [1,0]]), 			# small L
			   rotations([[0, 0], [1, 0], [2,0],[-2,0],[-1,0]]), # line 5
			   rotations([[0, 0], [1, 0],[-1,0],[-1,-1],[0,-1]])] # l Bold
	Cheat_Block = [[[0, 0]]];
  def self.next_piece (board)
	if(!@@cheated)
		MyPiece.new(All_My_Pieces.sample, board)
	else
		@@cheated = false
		board.score -= 100
		MyPiece.new(Cheat_Block,board) 
	end
  end
  	  def self.cheated= c
	  	@@cheated = c
	  end
	  def self.cheated 
		@cheated
	  end
end

class MyBoard < Board
	  def initialize (game)
		@grid = Array.new(num_rows) {Array.new(num_columns)}
		@current_block = MyPiece.next_piece(self)
		@score = 0
		@game = game
		@delay = 500
	  end
	   # gets the next piece
	  def next_piece
		@current_block = MyPiece.next_piece(self)
		@current_pos = nil
	  end
	  # gets the information from the current piece about where it is and uses this
	  # to store the piece on the board itself.  Then calls remove_filled.
	  def store_current
		locations = @current_block.current_rotation
		displacement = @current_block.position
		
		s = locations.size
		s -= 1 
		(0..s).each{|index| 
		  current = locations[index];
		  @grid[current[1]+displacement[1]][current[0]+displacement[0]] = 
		  @current_pos[index]
		}
		remove_filled
		@delay = [@delay - 2, 80].max
	  end
	  
		# rotates the current piece 180 degrees
	  def rotate_180
		if !game_over? and @game.is_running?
		  @current_block.move(0, 0, 1)
		  @current_block.move(0, 0, 1)
		end
		draw
	  end
	  # get score value
	  def score= s
		@score = s
		end
		
end

class MyTetris < Tetris
  # creates a canvas and the board that interacts with it
  def set_board
    @canvas = TetrisCanvas.new
    @board = MyBoard.new(self)
    @canvas.place(@board.block_size * @board.num_rows + 3,
                  @board.block_size * @board.num_columns + 6, 24, 80)
    @board.draw
  end
  def key_bindings  
    @root.bind('n', proc {self.new_game}) 

    @root.bind('p', proc {self.pause}) 

    @root.bind('q', proc {exitProgram})
    
    @root.bind('a', proc {@board.move_left})
    @root.bind('Left', proc {@board.move_left}) 
    
    @root.bind('d', proc {@board.move_right})
    @root.bind('Right', proc {@board.move_right}) 

    @root.bind('s', proc {@board.rotate_clockwise})
    @root.bind('Down', proc {@board.rotate_clockwise})

    @root.bind('w', proc {@board.rotate_counter_clockwise})
    @root.bind('Up', proc {@board.rotate_counter_clockwise}) 
    
    @root.bind('space' , proc {@board.drop_all_the_way})

	@root.bind('u' , proc {@board.rotate_180}) 
	
		@root.bind('c',proc {
		if (@board.score >= 100 && !@board.game_over?)
			MyPiece.cheated = true
			end})
  end
end