# frozen_string_literal: true

require_relative 'piece'

# This class represents a rook.
#
class Rook < Piece
  attr_reader :castling_sq

  def initialize(clr, id = :R)
    super(clr, id)
    @news = %i[N E W S]
    @first_move = true
  end

  def update_castling_sq(sqr)
    @castling_sq = sqr
  end

  def update_first_move(bool)
    @first_move = bool
  end
end
