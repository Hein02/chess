# frozen_string_literal: true

require_relative 'king'

# This class represents a pawn.
#
class Pawn < King
  def initialize(clr, id = :P)
    super(clr, id)
    @news = clr == :w ? %i[NE N NW] : %i[SE S SW]
  end

  def movement(cur_sq, sqrs)
    paths = collect_paths(cur_sq, sqrs)
    pawn_paths = add_one_sq(paths) if @first_move == true
    {
      moves: find_moves(pawn_paths, sqrs),
      captures: find_captures(pawn_paths, sqrs)
    }
  end

  def add_one_sq(paths)
    paths.each_with_object({}) do |(dir, path), hash|
      one_sq = find_path(path[0], dir) { |_, cnt| cnt == 1 }
      hash[dir] = path.concat(one_sq) if %i[N S].include?(dir)
    end
  end
end
