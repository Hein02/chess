# frozen_string_literal: true

# unicode chess-piece symbols look-up
#
PCS_SYMS = {
  b: {
    K: "\u2654",
    Q: "\u2655",
    R: "\u2656",
    B: "\u2657",
    N: "\u2658",
    P: "\u2659"
  },
  w: {
    K: "\u265a",
    Q: "\u265b",
    R: "\u265c",
    B: "\u265d",
    N: "\u265e",
    P: "\u265f"
  }
}.freeze

# This class represents pieces.
#
class Piece
  def initialize(clr, id)
    @clr = clr
    @id = id
    @sym = PCS_SYMS[clr][id]
  end

  def to_s
    @sym
  end

  def find_hor_dir(dir)
    dir[-1].to_sym if dir.end_with?('W', 'E')
  end
end
