# frozen_string_literal: true

require_relative 'king'

# This class represents a pawn.
#
class Pawn < King
  def initialize(clr, id = :P)
    super(clr, id)
    @news = clr == :w ? %i[NE N NW] : %i[SE S SW]
    @first_move = true
    @en_pas_sq = nil
  end

  def movement(cur_sq, sqrs)
    paths = collect_paths(cur_sq)
    move_paths = select_mv_pths(paths)
    cap_paths = select_cp_pths(paths)
    movement = {
      moves: find_moves(move_paths, sqrs),
      captures: find_captures(cap_paths, sqrs)
    }
    movement[:en_pas] = find_sq_behind(@en_pas_sq) if @en_pas_sq
    movement
  end

  def select_mv_pths(paths)
    paths.select { |dir, _| %i[N S].include?(dir) }
  end

  def select_cp_pths(paths)
    paths.reject { |dir, _| %i[N S].include?(dir) }
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

  def find_sq_behind(sqr)
    dir = @clr == :w ? 1 : -1
    "#{sqr[0]}#{sqr[1].to_i + dir}".to_sym
  end

  def update_en_pas_sq(sqr)
    @en_pas_sq = sqr
  end
end
