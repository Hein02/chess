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
    castling_sqs = castling(sqrs)
    movement[:castling] = castling_sqs unless castling_sqs.empty?
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
    return [] if @first_move == false

    rooks_sqs = find_rooks_sqs(sqrs)
    return [] if rooks_sqs.empty?

    pth_nt_under_atk = pth_nt_under_atk(rooks_sqs, sqrs)
    return [] if pth_nt_under_atk.empty?

    update_rooks(rooks_sqs, sqrs, pth_nt_under_atk)
    king_sqs(pth_nt_under_atk)
  end

  def find_rooks_sqs(sqrs)
    rooks_sqs = @clr == :w ? %i[a1 h1] : %i[a8 h8]
    rooks_sqs.select do |sq|
      sqrs[sq] && sqrs[sq].id == :R && sqrs[sq].first_move == true && sqrs[sq].clr == @clr
    end
  end

  def match_rk_and_pth(rooks_sqs)
    pth_for_rk = {
      a1: %i[d1 c1], h1: %i[f1 g1],
      a8: %i[d8 c8], h8: %i[f8 g8]
    }
    rooks_sqs.map { |sq| pth_for_rk[sq] }
  end

  def pth_nt_under_atk(rooks_sqs, sqrs)
    castling_pths = match_rk_and_pth(rooks_sqs)
    castling_pths.select do |path|
      path.all? do |sq|
        sqrs[sq].nil? && !in_check?(sq, sqrs)
      end
    end
  end

  def rooks_dest(castling_pths)
    castling_pths.map(&:first)
  end

  def update_rooks(rooks_sqs, sqrs, castling_paths)
    rooks_dests = rooks_dest(castling_paths)
    rooks_dests.each_with_index do |dest, idx|
      sqrs[rooks_sqs[idx]]&.update_castling_sq(dest)
    end
  end

  def king_sqs(pth_nt_under_atk)
    pth_nt_under_atk.map(&:last)
  end
end
