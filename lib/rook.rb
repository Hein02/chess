# frozen_string_literal: true

require_relative 'piece'

# This class represents a rook.
#
class Rook < Piece
  def initialize(clr, id = :R)
    super(clr, id)
    @news = %i[N E W S]
    @first_move = true
  end
end
