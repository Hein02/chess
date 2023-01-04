# frozen_string_literal: true

require_relative 'piece'

# This class represents a bishop
#
class Bishop < Piece
  def initialize(clr, id = :B)
    super(clr, id)
  end
end
