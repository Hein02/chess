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
