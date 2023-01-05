# frozen_string_literal: true

require_relative 'piece'

# This class represent a queen.
#
class Queen < Piece
  def initialize(clr, id = :Q)
    super(clr, id)
    @news = %i[N E W S NE NW SE SW]
  end
end
