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

  def collect_paths(cur_sq)
    @news.each_with_object({}) do |dir, paths|
      paths[dir] = if %i[N S].include?(dir)
                     find_move_path(cur_sq, dir)
                   else
                     paths[dir] = find_path(cur_sq, dir) { |_, cnt| cnt == 1 }
                   end
    end
  end

  def find_move_path(cur_sq, dir)
    movable = @first_move ? 2 : 1
    find_path(cur_sq, dir) { |_, cnt| cnt == movable }
  end
end
