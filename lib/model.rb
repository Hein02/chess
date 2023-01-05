# frozen_string_literal: true

require_relative 'board'
require_relative 'player'

# This class acts as a central command center of a Chess game.
#
class Model
  def initialize(brd, w_player, b_player)
    @brd = brd
    @cur_p = w_player
    @w_player = w_player
    @b_player = b_player
  end

  def self.new_game
    brd = Board.init_setup
    w_player = Player.new(:w, 'a')
    b_player = Player.new(:b, 'b')
    Model.new(brd, w_player, b_player)
  end

  def select_pc(sqr)
    @brd.find_pc(sqr)
  end

  def find_movement(piece, sqr, sqrs)
    piece.movement(sqr, sqrs)
  end

  def move_pc(from, to)
    @brd.reassign_pc(from, to)
  end

  def record_king_sqr(sqr)
    @cur_p.update_king_sqr(sqr)
  end

  def move_back(from, to)
    @brd.reassign_pc(to, from)
  end

  def record_first_move(piece)
    piece.update_first_move(true)
  end

  # En_passant Handlers
  def two_sq_adv?(from, to)
    (from[1].to_i - to[1].to_i).abs == 2
  end

  def first_move?(piece)
    piece.first_move
  end

  def find_adj_e_pwn(piece, sqr)
    left = piece.find_adj_sq(sqr, :W, nil)
    right = piece.find_adj_sq(sqr, :E, nil)
    e_pwn_sq = [left, right].find { |sq| select_pc(sq) }
    select_pc(e_pwn_sq)
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

  # Player in check
  def in_check?
    dbles = create_dbles
    dbles.any? do |dbl|
      movement = dbl.movement(@cur_p.king_sqr, sqrs)
      captures = movement[:captures]
      dbl_exists?(dbl, captures)
    end
  end

  def create_dbles
    [Queen, Rook, Bishop, Knight, Pawn, King].map { |dbl| dbl.new(@cur_p.clr) }
  end

  def dbl_exists?(dbl, captures)
    captures.any? do |sqr|
      found = select_pc(sqr)
      found && found.clr != @cur_p.clr && found.id == dbl.id
    end
  end

  # TODO: check if the king can make castling move

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

  def pc_id(piece)
    piece.id
  end
end

w_k = King.new(:w)
b_k = King.new(:b)

w_q = Queen.new(:w)
b_q = Queen.new(:b)

w_b = Bishop.new(:w)
b_b = Bishop.new(:b)

w_r = Rook.new(:w)
b_r = Rook.new(:b)

w_n = Knight.new(:w)
b_r = Knight.new(:b)

w_p = Pawn.new(:w)
b_p = Pawn.new(:b)

brd = Board.new(Board.empty_sqrs)
w_player = Player.new(:w, 'a')
b_player = Player.new(:b, 'b')
mdl = Model.new(brd, w_player, b_player)

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
mdl.place_pc(w_k, :e1)
mdl.place_pc(b_k, :d3)
puts mdl.in_check?
