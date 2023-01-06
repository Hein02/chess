# frozen_string_literal: true

# This module handles en passant
#
module EnPassant
  # En_passant Handlers
  def handle_en_passant(piece, from, to, movement)
    add_en_pas_sq(piece, to) if piece.first_move && two_sq_adv?(from, to)
    en_pas = movement[:en_pas]
    make_en_pas_mv(piece) if en_pas == to
  end

  def two_sq_adv?(from, to)
    (from[1].to_i - to[1].to_i).abs == 2
  end

  def find_adj_e_pwn(piece, sqr)
    left = piece.find_adj_sq(sqr, :W, nil)
    right = piece.find_adj_sq(sqr, :E, nil)
    e_pwn_sq = [left, right].find { |sq| find_pc(sq) }
    find_pc(e_pwn_sq)
  end

  def remove_pwn_behind(piece)
    sqr = piece.en_pas_sq
    remove_pc(sqr)
  end

  # follow after move
  # add_en_pas_sq(piece, to) if pc_id(piece) == :P && first_move?(piece) && two_sq_adv?(from, to)
  def add_en_pas_sq(piece, to)
    adj_e_pwn = find_adj_e_pwn(piece, to)
    adj_e_pwn&.update_en_pas_sq(to)
  end

  # follow after move
  # movement = piece.movement(sqr, sqrs)
  # check if there is an en_passant move and the destination is inside movement[:en_pas]
  # make_en_pas_mv(piece) if movement[:en_pas] && movement[:en_pas] == to
  def make_en_pas_mv(piece)
    remove_pwn_behind(piece)
    piece.update_en_pas_sq(nil)
  end
end
