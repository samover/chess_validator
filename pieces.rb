# initialize the chesspieces and their possible movement
class ChessPiece
  attr_reader :color, :jump, :mult, :moves
end

# PAWN
class Pawn < ChessPiece
  def initialize(color)
    @color = color
    @first_move = true
    @moves = [10, 20, 9, 11]
  end
end

# BISHOP
class Bishop < ChessPiece
  def initialize(color)
    @color = color
    @moves = [9, 11]
    @mult = true
  end
end

# KNIGHT
class Knight < ChessPiece
  def initialize(color)
    @color = color
    @moves = [8, 12, 19, 21]
    @jump = true
  end
end

# ROOK
class Rook < ChessPiece
  def initialize(color)
    @color = color
    @moves = [10, 1]
    @mult = true
  end
end

# QUEEN
class Queen < ChessPiece
  def initialize(color)
    @color = color
    @moves = [1, 9, 10, 11]
    @mult = true
  end
end

# KING
class King < ChessPiece
  def initialize(color)
    @color = color
    @moves = [1, 9, 10, 11]
  end
end
