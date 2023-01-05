# frozen_string_literal: true

require_relative 'piece'

# This class represents a king.
#
class King < Piece
  def initialize(clr, id = :K)
    super(clr, id)
    @news = %i[N E W S NE NW SE SW]
  end

  def collect_paths(cur_sq)
    @news.each_with_object({}) do |dir, paths|
      paths[dir] = find_path(cur_sq, dir) do |_, cnt|
        cnt == 1
      end
    end
  end
end
