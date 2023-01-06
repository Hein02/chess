# frozen_string_literal: true

# This module handles castling
#
module Castling
  # Castling handler
  def handle_castling(piece, movement, to)
    rook_sq = piece.clr == :w ? { g1: :h1, c1: :a1 } : { g8: :h8, c8: :a8 }
    castling = movement[:castling]
    return unless castling&.include?(to)

    rook_from = rook_sq[to]
    rook = select_pc(rook_from)
    rook_to = rook.castling_sq
    @brd.reassign_pc(rook_from, rook_to)
  end
end
