# frozen_string_literal: true

require_relative 'king'

# This class represents a pawn.
#
class Pawn < King
  def initialize(clr, id = :P)
    super(clr, id)
    @news = clr == :w ? %i[NE N NW] : %i[SE S SW]
    @first_move = true
  end

  def movement(cur_sq, sqrs)
    paths = collect_paths(cur_sq)
    move_path = find_move_path(paths, sqrs)
    modified_move_path = add_one_sq(move_path) if @first_move == true
    {
      moves: find_moves(modified_move_path, sqrs),
      captures: find_captures(paths, sqrs)
    }
  end

  def find_move_path(paths, sqrs)
    paths.select { |dir, path| %i[N S].include?(dir) && sqrs[path[0]].nil? }
  end

  def add_one_sq(fl_path)
    fl_path.each_with_object({}) do |(dir, path), hash|
      if path.empty?
        hash[dir] = path
      else
        one_sq = find_path(path[0], dir) { |_, cnt| cnt == 1 }
        hash[dir] = path.concat(one_sq)
      end
    end
  end
end
