# frozen_string_literal: true

require_relative 'board'

# This class acts as a central command center of a Chess game.
#
class Model
  def initialize(board)
    @board = board
  end

  def self.new_game
    brd = Board.init_setup
    Model.new(brd)
  end
end
