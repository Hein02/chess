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
NEWS = { N: 1, E: 1, W: -1, S: -1 }.freeze

# This class represents pieces.
#
class Piece
  attr_reader :clr

  def initialize(clr, id)
    @clr = clr
    @id = id
    @sym = PCS_SYMS[clr][id]
    @news = %i[N E W S NE NW SE SW]
  end

  def movement(cur_sq, sqrs)
    paths = collect_paths(cur_sq, sqrs)
    {
      moves: find_moves(paths, sqrs),
      captures: find_captures(paths, sqrs)
    }
  end

  def collect_paths(cur_sq, sqrs)
    @news.each_with_object({}) do |dir, paths|
      paths[dir] = find_path(cur_sq, dir) do |sqr, _|
        sqrs[sqr]
      end
    end
  end

  def find_moves(paths, sqrs)
    paths.values.flatten.select do |sqr|
      sqrs[sqr].nil?
    end
  end

  def find_captures(paths, sqrs)
    paths.values.flatten.select do |sqr|
      sqrs[sqr] && sqrs[sqr].clr != @color
    end
  end

  def find_path(cur_sq, dir, &stop_after)
    stack = [cur_sq]
    fl_dir = find_fl_dir(dir)
    rk_dir = find_rk_dir(dir)
    traverse(stack, fl_dir, rk_dir, &stop_after)
  end

  def to_s
    @sym
  end

  def traverse(stack, fl_dir, rk_dir, path = [], cnt = 1, &stop_after)
    cur_sq = stack.pop
    adj_sq = find_adj_sq(cur_sq, fl_dir, rk_dir)
    return path if adj_sq.nil?

    cond = stop_after.call(adj_sq, cnt) if block_given?
    return path << adj_sq if cond

    stack << adj_sq
    path << adj_sq
    traverse(stack, fl_dir, rk_dir, path, cnt + 1, &stop_after)
  end

  def find_adj_sq(cur_sq, fl_dir, rk_dir)
    return if cur_sq.nil?

    cur_fl = cur_sq[0].to_sym
    cur_rk = cur_sq[1].to_sym

    adj_fl = find_adj_fl(cur_fl, fl_dir)
    adj_rk = find_adj_rk(cur_rk, rk_dir)

    "#{adj_fl}#{adj_rk}".to_sym if adj_fl && adj_rk
  end

  # @param cur_rk [Symbol] the rank of the current sqr
  # @param rk_dir [Symbol] either :N or :S
  # @return [Symbol] the rank of the adjacent sqr
  #
  def find_adj_rk(cur_rk, rk_dir)
    return cur_rk if rk_dir.nil?

    cur_rk_idx = RANKS.index(cur_rk)
    adj_rk_idx = cur_rk_idx + NEWS[rk_dir]
    return if adj_rk_idx.negative? # prevent from picking up the last rank when idx is negative

    RANKS[adj_rk_idx]
  end

  # @param cur_fl [Symbol] the file of the current sqr
  # @param fl_dir [Symbol] either :E or :W
  # @return [Symbol] the file of the adjacent sqr
  #
  def find_adj_fl(cur_fl, fl_dir)
    return cur_fl if fl_dir.nil?

    cur_fl_idx = FILES.index(cur_fl)
    adj_fl_idx = cur_fl_idx + NEWS[fl_dir]
    return if adj_fl_idx.negative? # prevent from picking up the last file when idx is negative

    FILES[adj_fl_idx]
  end

  # @param dir [Symbol] It can either be one-character or two-character symbol.
  #   It must start with either N or S.
  #   It must end with E or W if it is two-character symbol
  # @example :N, :E, :W, :S, :NE, :NW, :SE, :SW
  # @return [Symbol, nil] It can be one of :E and :W, or nil if dir does not ends with either E or W.
  #
  def find_fl_dir(dir)
    dir[-1].to_sym if dir.end_with?('E', 'W')
  end

  def find_rk_dir(dir)
    dir[0].to_sym if dir.start_with?('N', 'S')
  end
end
