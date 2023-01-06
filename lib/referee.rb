# frozen_string_literal: true

class GameError < StandardError
end

# This class checks for error
#
class Referee
  def no_pc(piece)
    raise GameError.new, 'No piece' unless piece
  end

  def not_cur_p_pc(pc_clr, cur_p_clr)
    raise GameError.new, 'Not your piece' unless pc_clr == cur_p_clr
  end

  def no_movements_avail(movement)
    all_moves = movement.values.flatten
    raise GameError.new, 'No movements available' if all_moves.empty?
  end

  def invalid_mv(movement, to)
    all_moves = movement.values.flatten
    raise GameError.new, 'Invalid move' if all_moves.none?(to)
  end

  def player_in_check
    raise GameError.new, 'Player in check'
  end
end
