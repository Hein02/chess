# frozen_string_literal: true

require_relative 'piece'

# This class represents a king.
#
class King < Piece
  def initialize(clr, id = :K)
    super(clr, id)
    @first_move = true
  end

  def movement(cur_sq, sqrs)
    paths = collect_paths(cur_sq, sqrs)
    movement = {
      moves: find_moves(paths, sqrs),
      captures: find_captures(paths, sqrs)
    }
    castling = castling(sqrs) if @first_move == true
    movement[:castling] = castling unless castling.empty?
    movement
  end

  def collect_paths(*args)
    cur_sq = args[0]
    @news.each_with_object({}) do |dir, paths|
      paths[dir] = find_path(cur_sq, dir) do |_, cnt|
        cnt == 1
      end
    end
  end

  # King in check
  def in_check?(cur_sq, sqrs)
    dbles = create_dbles
    dbles.any? do |dbl|
      captures = dbl.fake_captures(cur_sq, sqrs)
      dbl_exists?(dbl, captures, sqrs)
    end
  end

  def create_dbles
    [Queen, Rook, Bishop, Knight, Pawn, King].map { |dbl| dbl.new(@clr) }
  end

  def dbl_exists?(dbl, captures, sqrs)
    captures.any? do |sqr|
      found = sqrs[sqr]
      found && found.clr != @clr && found.id == dbl.id
    end
  end

  # Castling
  def castling(sqrs)
    king_dests = []
    rooks_sqs = find_rooks_sqs(sqrs)
    return king_dests if rooks_sqs.empty?

    castling_pths = castling_pths(rooks_sqs, sqrs)
    return king_dests if castling_pths.empty?

    castling_pths.each do |rk, pth|
      sqrs[rk].update_castling_sq(pth[0])
      king_dests << pth[1]
    end
    king_dests
  end

  def find_rooks_sqs(sqrs)
    rooks_sqs = @clr == :w ? %i[a1 h1] : %i[a8 h8]
    rooks_sqs.select do |sq|
      sqrs[sq] && sqrs[sq].id == :R && sqrs[sq].first_move == true && sqrs[sq].clr == @clr
    end
  end

  def castling_pths(rooks_sqs, sqrs)
    rook_n_pth = {
      a1: %i[d1 c1], h1: %i[f1 g1], a8: %i[d8 c8], h8: %i[f8 g8]
    }
    rook_n_pth.select { |rk, _| rooks_sqs.include?(rk) }
              .select do |_, path|
                path.all? do |sq|
                  sqrs[sq].nil? && !in_check?(sq, sqrs)
                end
              end
  end
end
