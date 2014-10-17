require './piece'
#require "debugger"

class Board

	attr_reader :rows
	def initialize
		@rows = Array.new(8) { Array.new(8) }
		fill_the_board
	end

	def [](pos)
		i, j = pos
		@rows[i][j]
	end

	def []=(pos,piece)
		i, j = pos
		@rows[i][j] = piece
	end

	def add_a_piece(pos, piece)
		self[pos] = piece
	end


	def in_range?(pos)
		pos.all? {|el| el.between?(0, 7)}
	end

	def deep_dup
		dup_board = Board.new
		@rows.flatten.compact.each do |piece|
			piece.class.new(dup_board, piece.pos, piece.color)
		end
		dup_board
	end


	def fill_pawns(color)
		row_color = {:white => [0, 1, 2], :black => [5, 6, 7]}
		row_color[color].each do |y|
			(0..7).each do |x|
				if y % 2 == 0
					next if x % 2 != 0
				elsif y % 2 != 0
					next if x % 2 == 0
				end
				Piece.new(self, [y, x], color)
			end
		end
  	end

	def fill_the_board
		fill_pawns(:white)
		fill_pawns(:black)	
	end

	def display 

		@rows.map do |row|
			row.map do |piece|
				piece.nil? ? "." : piece.display 
			end.join('  ')
		end.join("\n")
	end
end

b = Board.new
puts b.display
# b.rows[5][1].perform_slide([4, 2])
# puts
# b.rows[2][4].perform_slide([3, 3])
# puts b.display
# puts
# b.rows[4][2].perform_jump([2, 4])
# puts b.display
#p b.rows[4][2].valid_move_seq?([[2, 4],[1,5]])
# puts
# p b.rows[4][2].perform_moves([[2, 4],[1,5]])
# #puts
# puts b.display


#p b.rows[5][3].perform_slide([4, 3])
#p b.rows[5][3].valid_move_seq?([[4, 3]])



