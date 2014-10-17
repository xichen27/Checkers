
class IllegalMoveError < RuntimeError; end

class Piece

	MOVE_DIFFS_W = [[1, 1], [1, -1]]
	MOVE_DIFFS_B = [[-1, 1], [-1, -1]] 

	attr_reader :board, :pos, :color

	def initialize(board, pos, color, king = false)
		@board = board
		@pos = pos
		@color = color
		@king = king

		@board.add_a_piece(pos, self)
	end

	def move_diffs
		if king 
			MOVE_DIFFS_B + MOVE_DIFFS_W
		else
			color == :white ? MOVE_DIFFS_W : MOVE_DIFFS_B
		end
	end

	def display
		if color == :white
			@king? :WK : :WP  
		elsif color == :black
			@king? :BK : :BP 
		end 
	end	



	def perform_slide(end_pos)
		return false unless @board.in_range?(end_pos)
		return false unless adj_diag(color).include?(end_pos)
		return false unless @board[end_pos].nil?

		@board[end_pos] = self
		@board[pos] = nil
		@pos = end_pos

		promote_to_king

		true
	end

	def perform_jump(end_pos)
		return false unless @board.in_range?(end_pos)
		return false unless adj_diag(color).include?(space_between(end_pos))
		return false if @board[space_between[end_pos]].nil? 
		return false if @board[space_between[end_pos]].color == color
		return false unless @board[end_pos].nil?


		@board[end_pos] = self
		@board[pos] = nil
		@pos = end_pos
		@board[space_between[end_pos]] = nil

		promote_to_king

		true
	end

	def perform_move!(move_sequence)
		if move_sequence.length == 1
			unless perform_slide(move_sequence[0]) || perform_jump(move_sequence[0])
				raise IllegalMoveError
			end
		else 
			move_sequence.each do |move|
				unless perform_jump(move)
					raise IllegalMoveError
				end
			end
		end
	end

	def valid_move_seq?(move_sequence)
		test_board = @board.deep_dup
		test_piece = Piece.new(test_board, pos, color, king)
		test_piece.perform_move!(move_sequence)
	rescue IllegalMoveError
		false
	else
		true
	end

	def perform_move(move_sequence)
		if valid_move_seq?(move_sequence)
			perform_move!(move_sequence)
		else
			raise IllegalMoveError
		end
	end


	def adj_diag(color)
		adj_diag = []
		
		move_diffs(color).each do |diff|
			adj_diag << [pos[0] + diff[0], pos[1] + diff[1]]
		end
		adj_diag
	end

	def space_between(end_pos)
		between_y, between_x = (pos[0] + end_pos[0])/2.0, (pos[1] + end_pos[1])/2.0
		[between_y, between_x]
	end

	def promote_to_king
		back_row = (color == white)? 7 : 0
		if pos[0] == back_row
			@king = true
		end
	end

end



