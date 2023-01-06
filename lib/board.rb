# frozen_string_literal: true

# This class represents the chess board.
#
class Board
  def initialize(sqrs = Board.empty_sqrs)
    @sqrs = sqrs
  end

  def sqrs
    @sqrs.dup
  end

  # This method initializes a board that has pieces at their respective initial squares.
  #
  def self.init_setup
    w_set = Board.chess_set(:w)
    b_set = Board.chess_set(:b)
    sqrs = Board.empty_sqrs
    w_set.each { |sqr, pc| sqrs[sqr] = pc }
    b_set.each { |sqr, pc| sqrs[sqr] = pc }
    Board.new(sqrs)
  end

  # This method can generate two different 16-pieces chess set with their initial squares, based on the color.
  #
  def self.chess_set(clr)
    pwns_rnk = clr == :w ? '2' : '7'
    pcs_rnk = clr == :w ? '1' : '8'
    pcs = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook, Pawn].freeze
    FILES.each_with_object({}).with_index do |(file, sqrs), idx|
      pwn_at = "#{file}#{pwns_rnk}".to_sym
      pc_at = "#{file}#{pcs_rnk}".to_sym
      sqrs[pwn_at] = pcs[8].new(clr)
      sqrs[pc_at] = pcs[idx].new(clr)
    end
  end

  # This method generate empty sqrs
  #
  def self.empty_sqrs
    sqrs = %i[
      a8 b8 c8 d8 e8 f8 g8 h8 a7 b7 c7 d7 e7 f7 g7 h7
      a6 b6 c6 d6 e6 f6 g6 h6 a5 b5 c5 d5 e5 f5 g5 h5
      a4 b4 c4 d4 e4 f4 g4 h4 a3 b3 c3 d3 e3 f3 g3 h3
      a2 b2 c2 d2 e2 f2 g2 h2 a1 b1 c1 d1 e1 f1 g1 h1
    ].freeze
    sqrs.each_with_object({}) { |sqr, brd| brd[sqr] = nil }
  end

  def find_pc(sqr)
    @sqrs[sqr]
  end

  def assign_pc(piece, sqr)
    @sqrs[sqr] = piece
  end

  def remove_pc(sqr)
    @sqrs[sqr] = nil
  end

  def reassign_pc(from, to)
    pc = find_pc(from)
    assign_pc(pc, to)
    remove_pc(from)
  end
end
