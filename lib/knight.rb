# frozen_string_literal: true

require_relative 'piece'

# This class represents a knight
#
class Knight < Piece
  def initialize(clr, id = :N)
    super(clr, id)
    @news = %i[NE NW SE SW EN ES WN WS]
  end

  def knight_find_path(cur_sq, dir)
    two_sq_dir = dir[0].to_sym
    one_sq_dir = dir[1].to_sym
    two_sq_adv = find_path(cur_sq, two_sq_dir) { |_, cnt| cnt == 2 }
    cur_sq = two_sq_adv[1]
    find_path(cur_sq, one_sq_dir) { |_, cnt| cnt == 1 }
  end
end
