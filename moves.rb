# The class 'Moves' reads in the all the moves for a file,
# and has a method to convert the algebraic notation of the move
# to the decimal positions on the 0x99 chess board
class Moves
  attr_reader :moves

  def initialize(moves_file)
    @moves = init_moves(moves_file)
  end

  def init_moves(moves_file)
    IO.read(__dir__ + moves_file).scan(/(\w\d)\s(\w\d)/)
  end

  def alg_to_dec(position)
    conv = { a: 1, b: 2, c: 3, d: 4, e: 5, f: 6, g: 7, h: 8 }
    conv[position[0].to_sym] + (position[1].to_i * 10)
  end
end
