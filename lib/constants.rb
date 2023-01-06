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

RANKS = %i[1 2 3 4 5 6 7 8].freeze
FILES = %i[a b c d e f g h].freeze
NEWS = { N: 1, E: 1, W: -1, S: -1 }.freeze