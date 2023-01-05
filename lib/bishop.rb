# frozen_string_literal: true

require_relative 'queen'

# This class represents a bishop
#
class Bishop < Queen
  def initialize(clr, id = :B)
    super(clr, id)
    @news = %i[NE NW SE SW]
  end
end
