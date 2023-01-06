# frozen_string_literal: true

# This module finds out about check and checkmate.
#
module CheckNCheckmate
  # Player in check
  def in_check?
    king_sq = cur_p_king_sqr
    king = find_pc(king_sq)
    king.in_check?(king_sq, sqrs)
  end

  def cur_p_king_sqr
    @cur_p.king_sqr
  end

  # Checkmate
  def checkmate?(pcs = cur_p_pcs.to_a)
    return true if pcs.empty?

    sqr, pc = pcs.pop
    tst_brd = Board.new(sqrs)
    tst_sqs = tst_brd.sqrs
    movement = pc.movement(sqr, tst_sqs)
    moves = movement[:moves] + movement[:captures]

    check = move_and_check?(moves, tst_brd, sqr, pc)
    return false if check == false

    checkmate?(pcs)
  end

  def move_and_check?(moves, brd, sqr, piece)
    return true if moves.empty?

    to = moves.pop
    brd.reassign_pc(sqr, to)
    record_king_sqr(to) if piece.id == :K
    king = brd.find_pc(cur_p_king_sqr)
    check = king.in_check?(cur_p_king_sqr, brd.sqrs)
    brd.reassign_pc(to, sqr)
    record_king_sqr(sqr) if piece.id == :K
    return false if check == false

    move_and_check?(moves, brd, sqr, piece)
  end

  def cur_p_pcs
    sqrs.select { |_, pc| pc && pc.clr == @cur_p.clr }
  end
end
