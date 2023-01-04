# frozen_string_literal: true

# This class represents a player.
#
class Player
  attr_reader :clr, :name, :king_sqr

  def initialize(clr, name)
    @clr = clr
    @name = name
    @king_sqr = clr == :w ? :e1 : :e8
  end

  def update_king_sqr(sqr)
    @king_sqr = sqr
  end
end
