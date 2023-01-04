# frozen_string_literal: true

require_relative 'board'

# This class acts as a central command center of a Chess game.
#
class Model
  def initialize(brd, player = nil)
    @brd = brd
    @cur_p = player
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
end
