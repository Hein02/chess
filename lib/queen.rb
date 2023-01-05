# frozen_string_literal: true

require_relative 'piece'

# This class represent a queen.
#
class Queen < Piece
  def initialize(clr, id = :Q)
    super(clr, id)
    @news = %i[N E W S NE NW SE SW]
  end

  def movement(cur_sq, sqrs)

  end

  def collect_paths(cur_sq, sqrs)
    @news.each_with_object({}) do |dir, paths|
      paths[dir] = find_path(cur_sq, dir) do |sqr, _|
        sqrs[sqr]
      end
    end
  end

  def find_moves(paths, sqrs)
    paths.values.flatten.select do |sqr|
      sqrs[sqr].nil?
    end
  end

end
