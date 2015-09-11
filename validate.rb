# The class 'Validate' is the engine of the validator app.
class Validate
  def initialize(board, moves)
    @board = board
    @moves = moves
    @pieces = {
      wP: Pawn.new(:white),   bP: Pawn.new(:black),
      wR: Rook.new(:white),   bR: Rook.new(:black),
      wN: Knight.new(:white), bN: Knight.new(:black),
      wB: Bishop.new(:white), bB: Bishop.new(:black),
      wQ: Queen.new(:white),  bQ: Queen.new(:black),
      wK: King.new(:white),   bK: King.new(:black)
    }
  end

  def write_to_file(result)
    File.write(__dir__ + '/results.txt', result.join("\n"))
  end

  def piece_on_position(alg_pos)
    @board.piece(dec_pos(alg_pos))
  end

  def dec_pos(alg_pos)
    @moves.alg_to_dec(alg_pos)
  end

  def calc_diff(dec_or, dec_tg)
    (dec_tg - dec_or).abs
  end

  def taken?(dest)
    dest.nil? ? false : true
  end

  def same_color?(piece, dest)
    piece.color == dest.color ? true : false
  end

  def target_own?(piece, dest)
    taken?(dest) && same_color?(piece, dest) ? true : false
  end

  def possible_move?(move)
    diff = calc_diff(move[:dec_or], move[:dec_tg])

    if diff == 0 ||
       target_own?(move[:piece], move[:dest]) ||
       legal_pawn_move?(move, diff) == false
      false
    elsif move[:piece].mult
      path(move[:piece], diff)
    elsif move[:piece].moves.include?(diff)
      [diff]
    else
      false
    end
  end

  def out_of_range?(steps)
    steps.any? { |step| @board.piece(step) == 0 } ? true : false
  end

  def path_blocked?(piece, steps)
    return false if piece.jump
    return true if  steps.any? do |step|
      @board.piece(step) != '--' || @board.piece(step) == 0
    end
  end

  def legal_pawn_move?(move, diff)
    if move[:piece].class != Pawn
      return
    elsif diff.abs == 11 && (target_own?(move[:piece], move[:dest]) ||
      !taken?(move[:dest]))
      false
    elsif move[:piece].color == :black
      false if  move[:dec_tg] > move[:dec_or] ||
                diff.abs == 20 && move[:alg_or][1] != '7'
    elsif move[:piece].color == :white
      false if  move[:dec_tg] < move[:dec_or] ||
                diff.abs == 20 && move[:alg_or][1] != '2'
    end
  end

  def path(piece, diff)
    piece.moves.select { |move| diff % move == 0 }
  end

  def create_steps_on_path(move, dec_or, dec_tg)
    range = [dec_or, dec_tg].sort
    (range[0]...range[1]).step(move.abs).collect { |num| num}[1..-1]
  end

  def trace_steps(move, path)
    path.select do |mover|
      steps = create_steps_on_path(mover, move[:dec_or], move[:dec_tg])
      steps.length > 6 ||
        out_of_range?(steps) ||
        path_blocked?(move[:piece], steps) ? false : true
    end
  end

  def check_path(move)
    path = possible_move?(move)
    return 'ILLEGAL' if path == false || path.empty? == []

    poss = trace_steps(move, path)
    return 'ILLEGAL' if poss.empty? || poss == false
    'LEGAL'
  end

  def validate_moves
    result = []

    @moves.moves.each do |origin, target|
      move = {  piece: @pieces[piece_on_position(origin).to_sym],
                dest: @pieces[piece_on_position(target).to_sym],
                alg_or: origin,
                alg_tg: target,
                dec_or: dec_pos(origin),
                dec_tg: dec_pos(target)
             }
      move[:piece].nil? ? result << 'ILLEGAL' : result << check_path(move)
    end

    write_to_file(result)
  end
end
