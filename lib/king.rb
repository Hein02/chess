# frozen_string_literal: true

require_relative 'piece'

# This class represents a king.
#
class King < Piece
  def initialize(clr, id = :K)
    super(clr, id)
  end

  def collect_paths(*args)
    cur_sq = args[0]
    @news.each_with_object({}) do |dir, paths|
      paths[dir] = find_path(cur_sq, dir) do |_, cnt|
        cnt == 1
      end
    end
  end

  def in_check?(cur_sq, sqrs)
    dbles = create_dbles
    dbles.any? do |dbl|
      movement = dbl.movement(cur_sq, sqrs)
      captures = movement[:captures]
      dbl_exists?(dbl, captures, sqrs)
    end
  end

  def create_dbles
    [Queen, Rook, Bishop, Knight, Pawn, King].map { |dbl| dbl.new(@clr) }
  end

  def dbl_exists?(dbl, captures, sqrs)
    captures.any? do |sqr|
      found = sqrs[sqr]
      found && found.clr != @clr && found.id == dbl.id
    end
  end
end
