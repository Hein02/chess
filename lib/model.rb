# frozen_string_literal: true

require_relative 'board'
require_relative 'player'
require_relative 'king'
require_relative 'queen'
require_relative 'bishop'
require_relative 'rook'
require_relative 'knight'
require_relative 'pawn'
require_relative 'check_n_checkmate'
require_relative 'constants'
require_relative 'referee'
require_relative 'en_passant'
require_relative 'castling'
require_relative 'savable'

# This class acts as a central command center of a Chess game.
#
class Model
  include CheckNCheckmate
  include EnPassant
  include Castling

  def initialize(brd, w_player, b_player, cur_p = nil, referee = nil)
    @brd = brd
    @cur_p = cur_p || w_player
    @w_player = w_player
    @b_player = b_player
    @referee = referee || Referee.new
  end

  def self.new_game(w_player_name = 'White', b_player_name = 'Black')
    brd = Board.init_setup
    w_player = Player.new(:w, w_player_name)
    b_player = Player.new(:b, b_player_name)
    Model.new(brd, w_player, b_player)
  end

  def self.load_game(file_dir)
    data = Model.load_data(file_dir)
    brd = data[:brd]
    w_player = data[:w_player]
    b_player = data[:b_player]
    cur_p = data[:cur_p]
    Model.new(brd, w_player, b_player, cur_p)
  end

  def self.load_data(file_dir)
    permitted_classes = [Symbol, Board, Rook, Knight, Bishop, Queen, King, Pawn, Player, Referee]
    return unless File.exist?(file_dir)

    YAML.load_file(file_dir, permitted_classes: permitted_classes, aliases: true, symbolize_names: true)
  end

  def select_pc(sqr)
    pc = find_pc(sqr)
    @referee.no_pc(pc)
    @referee.not_cur_p_pc(pc.clr, @cur_p.clr)
    pc
  end

  def move_pc(from, to, movement = {})
    @referee.invalid_mv(movement, to)
    @brd.reassign_pc(from, to)
    pc = find_pc(to)
    record_king_sqr(to) if pc.id == :K
    if in_check?
      reverse_move(from, to, pc)
    else
      not_in_check(pc, movement, to, from)
    end
  end

  def reverse_move(from, to, piece)
    @brd.reassign_pc(to, from)
    record_king_sqr(from) if piece.id == :K
    @referee.player_in_check
  end

  def not_in_check(piece, movement, to, from)
    record_first_move(piece) if piece.id == :P || piece.id == :K || piece.id == :R
    handle_castling(piece, movement, to) if piece.id == :K
    handle_en_passant(piece, from, to, movement) if piece.id == :P
    switch_player
  end

  def record_king_sqr(sqr)
    @cur_p.update_king_sqr(sqr)
  end

  def record_first_move(piece)
    piece.update_first_move(true)
  end

  def first_move?(piece)
    piece.first_move
  end

  def switch_player
    @cur_p = @cur_p == @w_player ? @b_player : @w_player
  end

  def sqrs
    @brd.sqrs
  end

  def remove_pc(sqr)
    @brd.remove_pc(sqr)
  end

  def place_pc(piece, sqr)
    @brd.assign_pc(piece, sqr)
  end

  def find_pc(sqr)
    @brd.find_pc(sqr)
  end

  def cur_p_name
    @cur_p.name
  end

  def find_movement(piece, sqr)
    movement = piece.movement(sqr, sqrs)
    @referee.no_movements_avail(movement)
    movement
  end
end

# w_k = King.new(:w)
# b_k = King.new(:b)

# w_q = Queen.new(:w)
# b_q = Queen.new(:b)

# w_b = Bishop.new(:w)
# b_b = Bishop.new(:b)

# w_r = Rook.new(:w)
# b_r = Rook.new(:b)

# w_n = Knight.new(:w)
# b_n = Knight.new(:b)

# w_p = Pawn.new(:w)
# b_p = Pawn.new(:b)

# brd = Board.new(Board.empty_sqrs)
# w_player = Player.new(:w, 'a')
# b_player = Player.new(:b, 'b')
# mdl = Model.new(brd, w_player, b_player)

# mdl.place_pc(b_p, :g7)
# mdl.place_pc(w_p, :f5)
# mdl.place_pc(b_p, :e6)

# two_sq = mdl.select_pc(:g7)
# from = :g7
# to = :g5
# mdl.move_pc(from, to)

# # Checking against rules
# puts mdl.first_move?(two_sq)
# puts mdl.two_sq_adv?(from, to)
# adj_e_pwn = mdl.find_adj_e_pwn(two_sq, :g5)
# # Allowing en_passant move to enemy pawn
# adj_e_pwn&.update_en_pas_sq(to)

# en_pas_pwn = mdl.select_pc(:f5)
# puts en_pas_pwn.movement(:f5, mdl.sqrs)

# # making en_passant move
# mdl.move_pc(:f5, :g6)
# mdl.remove_pwn_behind(en_pas_pwn)
# en_pas_pwn.update_en_pas_sq(nil)
# puts mdl.select_pc(:g5)

# in check
# mdl.place_pc(w_k, :e1)
# mdl.place_pc(b_q, :a2)
# puts mdl.in_check?

# castling
# mdl.place_pc(w_r, :a1)
# mdl.place_pc(w_k, :e1)
# movement = w_k.movement(:e1, mdl.sqrs)
# castling = movement[:castling]
# puts w_r.castling_sq
# to = :c1
# mdl.move_pc(:e1, to)
# mdl.move_pc(:a1, w_r.castling_sq) if castling.include?(to)
# print mdl.sqrs[:d1]

# checkmate
# mdl.place_pc(w_k, :e1)
# mdl.place_pc(w_q, :d5)
# mdl.place_pc(b_q, :a1)
# mdl.place_pc(b_r, :a2)
# print mdl.checkmate?

# game flow
# mdl = Model.new_game

# checkmate = [%i[e2 e4], %i[f7 f5], %i[e4 f5], %i[g7 g5], %i[d1 h5]] # checkmate

# checkmate.each do |input|
#   from, to = input
#   pc = mdl.select_pc(from)
#   mdl.move_pc(from, to)
#   mdl.record_king_sqr(to) if pc.id == :K
#   mdl.switch_player
#   puts mdl.checkmate? if mdl.in_check?
# end

# en_passant = [%i[d2 d4], %i[f7 f5], %i[d4 d5], %i[c7 c5], %i[d5 c6]] # en_passant

# en_passant.each do |input|
#   from, to = input
#   pc = mdl.select_pc(from)
#   mdl.move_pc(from, to)
#   movement = pc.movement(from, mdl.sqrs)
#   handle_en_passant(pc, from, to, movement, mdl) if pc.id == :P
#   mdl.record_king_sqr(to) if pc.id == :K
#   mdl.switch_player
# end
# pc = mdl.find_pc(:c5)
# print pc

# castling = [%i[g1 f3], %i[e7 e5], %i[e2 e4], %i[g7 g5], %i[f1 c4], %i[c7 c5], %i[e1 g1]] # castling
# castling.each do |input|
#   from, to = input
#   pc = mdl.select_pc(from)
#   movement = pc.movement(from, mdl.sqrs)
#   mdl.move_pc(from, to)
#   mdl.record_king_sqr(to) if pc.id == :K
#   handle_castling(pc, movement, to, mdl) if pc.id == :K
#   mdl.switch_player
# end
