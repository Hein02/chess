# frozen_string_literal: true

require 'colorize'

# This class represents the View of the Chess game.
#
# It is reponsible for providing information to the user.
#
class View
  COLORS = {
    movable: :green,
    capturable: :red,
    selected: :blue,
    light: :white,
    dark: :black
  }.freeze

  def initialize
    @selected = nil
    @moves = []
    @captures = []
  end

  def update(sqrs: {}, selected: nil, movement: {})
    @sqrs = sqrs
    @selected = selected
    @moves = movement.values_at(:moves, :castling).flatten
    en_pas = movement[:en_pas]
    captures = movement.values_at(:captures).flatten
    @captures = en_pas ? captures.push(en_pas) : captures
  end

  # Display the provided board as a Chess board
  #
  # @param squares [Hash] the game board
  #
  def board
    print x_axis
    @sqrs.each do |square, piece|
      if square[0] == 'a' # if a new role starts
        print y_axis(square[1])
        @light = (@light != true) # reserves square's color
      end
      @formatted = format_square(piece)
      colorize_square(square)
    end
    print "\n#{x_axis}\n"
  end

  def cur_p_name(name)
    puts "Your turn #{name}"
  end

  def saved_files(saved_files)
    saved_files.each_with_index do |saved_file, idx|
      puts saved_file.gsub('saved_files/', "[#{idx + 1}] ")
    end
  end

  private

  def colorize_square(square)
    @light = (@light != true)
    if @moves.include?(square)
      highlight(COLORS[:movable])
    elsif @captures.include?(square)
      highlight(COLORS[:capturable])
    elsif square == @selected
      highlight(COLORS[:selected])
    else
      @light == true ? highlight(COLORS[:light]) : highlight(COLORS[:dark])
    end
  end

  def highlight(color)
    print @formatted.colorize(background: color)
  end

  def info_square(info)
    " #{info} ".colorize(background: :light_black)
  end

  def x_axis
    [' ', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'].map { |alphabet| info_square(alphabet) }.join
  end

  def y_axis(tick)
    "\n#{info_square(tick)}"
  end

  def format_square(piece)
    " #{piece || ' '} "
  end
end
