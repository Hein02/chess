# frozen_string_literal: true

require_relative 'board'

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
    Model.new(brd)
  end

  def select_pc(sqr)
    @brd.find_pc(sqr)
  end

  def find_movement(piece, sqr)
    piece.movement(sqr)
  end

  def move_pc(from, to)
    @brd.reassign_pc(from, to)
  end

  def record_king_sqr(sqr)
    @cur_p.update_king_sqr(sqr)
  end

  def king_in_check?(piece)
    piece.in_check?
  end

  def move_back(from, to)
    @brd.reassign_pc(to, from)
  end

  def record_first_move(piece)
    piece.update_first_move(true)
  end

  # TODO: check if there is an en_passant move
  # TODO: check if the king can make castling move

  def switch_player
    @cur_p = @cur_p == @w_player ? @b_player : @w_player
  end
end
