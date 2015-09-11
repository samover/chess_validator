# Initialize the chessboard
# I use 0x99 board in order to trace illegal moves, i.e.
# moves that leave the board in stead of an 8x8 or 0x63
class ChessBoard
  attr_reader :board

  def initialize(board)
    @board = init_board(board)
  end

  def init_board(board)
    base_board = Array.new(36, 0)
    init_index = 25

    File.readlines(__dir__ + board)
      .collect { |line| line.scan(/\S\S/) }.each do |line|
        base_board.insert(init_index, line)
        init_index -= 2
      end
    base_board.flatten
  end

  def piece(position)
    @board[position]
  end
end
