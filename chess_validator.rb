# My validator checks whether given chess moves are valid on a given board
# and stores the result in a file "results.txt"
# TODO: 
# => implement movement rules in class 'pieces' instead of knitting them
# in class 'validate.
# => make variable names more readable, e.g. algebraic iso alg
# => pass board and moves files as CL variables (ARGV[0][1])

require 'fileutils'
require_relative 'pieces'
require_relative 'board'
require_relative 'moves'
require_relative 'validate'

Validate.new(ChessBoard.new('/complex_board.txt'),
                  Moves.new('/complex_moves.txt')).validate_moves

# For debugging purposes
puts "Are generated results the same as the expected results?"
puts FileUtils.compare_file(__dir__ + '/results.txt',
                            __dir__ + '/resultsCORRECT.txt').to_s.upcase
