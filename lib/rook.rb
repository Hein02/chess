# frozen_string_literal: true

require_relative 'queen'

# This class represents a rook.
#
class Rook < Queen
  def initialize(clr, id = :R)
    super(clr, id)
    @news = %i[N E W S]
  end
end
