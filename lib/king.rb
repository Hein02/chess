# frozen_string_literal: true

require_relative 'piece'

# This class represents a king.
#
class King < Piece
  def initialize(clr, id = :K)
    super(clr, id)
  end
end
