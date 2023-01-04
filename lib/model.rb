# frozen_string_literal: true

require_relative 'board'

# This class acts as a central command center of a Chess game.
#
class Model
  def initialize(brd)
    @brd = brd
  end

  def self.new_game
    brd = Board.init_setup
    Model.new(brd)
  end

  def select_pc(sqr)
    @brd.find_pc(sqr)
  end
end
