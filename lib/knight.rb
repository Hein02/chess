# frozen_string_literal: true

require_relative 'piece'

# This class represents a knight
#
class Knight < Piece
  def initialize(clr, id = :N)
    super(clr, id)
  end
end
