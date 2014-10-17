require_relative "board"

class Game

	def initialize
    @board = Board.new
    @current_player = :white
  end

  def play

    until over?
    begin 
      puts @board.display
      puts "Please choose a piece to move"
      piece_pos = gets.chomp.split('').map{|n| n.to_i}
      puts "Please enter your move sequence"
      move_sequence = gets.chomp.split(', ').map{|n| n.to_i}.each_slice(2).to_a
      @board[piece_pos].peform_moves(move_sequence)
    rescue
      puts "Invalid move"
      retry
    end

    @current_player = (@current_player == :white)? :black : :white
    end

    "#{@current_player} won."

  end

  def over?
    @board.rows.flatten.compact.none? do |piece| 
      piece.color != :white || piece.color != :black
    end
  end


end