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

FILES = %i[a b c d e f g h].freeze
RANKS = %i[1 2 3 4 5 6 7 8].freeze
NEWS = { N: 1, E: 1, W: -1, S: -1 }.freeze

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

  # @param dir [Symbol] It can either be one-character or two-character symbol.
  #   It must start with either N or S.
  #   It must end with E or W if it is two-character symbol
  # @example :N, :E, :W, :S, :NE, :NW, :SE, :SW
  # @return [Symbol, nil] It can be one of :E and :W, or nil if dir does not ends with either E or W.
  #
  def find_hor_dir(dir)
    dir[-1].to_sym if dir.end_with?('E', 'W')
  end

  def find_ver_dir(dir)
    dir[0].to_sym if dir.start_with?('N', 'S')
  end

  # @param cur_rnk [Symbol] the rank of the current sqr
  # @param hor_dir [Symbol] either :E or :W
  # @return [Symbol] the rank of the adjacent sqr
  #
  def find_adj_rnk(cur_rnk, hor_dir)
    return cur_rnk if hor_dir.nil?

    cur_rnk_idx = RANKS.index(cur_rnk)
    adj_rnk_idx = cur_rnk_idx + NEWS[hor_dir]
    return cur_rnk if adj_rnk_idx.negative? # prevent from picking up the last rank when idx is negative

    RANKS[adj_rnk_idx]
  end

  def find_adj_fl(cur_fl, ver_dir)
    return cur_fl if ver_dir.nil?

    cur_fl_idx = FILES.index(cur_fl)
    adj_fl_idx = cur_fl_idx + NEWS[ver_dir]
    return cur_fl if adj_fl_idx.negative?

    FILES[adj_fl_idx]
  end
end
