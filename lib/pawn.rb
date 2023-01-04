# frozen_string_literal: true

require_relative 'piece'

# This class represents a pawn.
#
class Pawn < Piece
  def initialize(clr, id = :P)
    super(clr, id)
  end
end
