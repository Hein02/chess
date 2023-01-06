# frozen_string_literal: true

require_relative 'model'
require_relative 'view'

# This class handles user's inputs, and also acts as a mediator between Model and View.
#
class Controller
  def initialize(model, view)
    @model = model
    @view = view
  end

  def self.start
    options = <<~HEREDOC
      [1] New game.
      [2] Load game
    HEREDOC
    option = user_input { puts options }
    option == '2' ? Controller.load_game : Controller.new_game
  end

  def self.user_input
    yield if block_given?
    gets.chomp
  end

  def self.new_game
    w_player_name = user_input { print 'Enter White player\'s name: ' }
    b_player_name = user_input { print 'Enter Black player\'s name: ' }
    model = Model.new_game(w_player_name, b_player_name)
    view = View.new
    Controller.new(model, view)
  end

  def self.load_game
    saved_files = Controller.retrieve_saved_files
    return Controller.init_new_game if saved_files.empty?

    Controller.display_saved_files(saved_files)
    file_num = Controller.user_input { print 'Select one: ' }
    file_dir = saved_files[file_num.to_i - 1]
    puts "Loading... #{Controller.file_name_only(file_dir)}"
    view = View.new
    model = Model.load_game(file_dir)
    Controller.new(model, view)
  end

  def self.retrieve_saved_files
    Dir['saved_files/*']
  end

  def self.init_new_game
    puts 'No save files to load. Please start a new game.'
    Controller.new_game
  end

  def self.display_saved_files(files)
    files.each_with_index do |file, idx|
      puts "[#{idx + 1}] " + Controller.file_name_only(file)
    end
  end

  def self.file_name_only(file)
    file.gsub('saved_files/', '')
  end

  def play
    loop do
      display_brd
      display_cur_p_name
      save = Controller.user_input { print 'Type s to save the game. ' }
      save_game if save == 's'
      select_n_move
      return puts 'Checkmate' if checkmate?
    rescue GameError => e
      puts e.message
    end
  end

  def display_brd(selected: nil, movement: {})
    @view.update(sqrs: sqrs, selected: selected, movement: movement)
    @view.board
  end

  def sqrs
    @model.sqrs
  end

  def display_cur_p_name
    @view.cur_p_name(cur_p_name)
  end

  def cur_p_name
    @model.cur_p_name
  end

  def select_n_move
    from = Controller.user_input { print 'Select a piece: ' }.to_sym
    movement = select_pc(from)
    display_brd(selected: from, movement: movement)
    to = Controller.user_input { print 'Move: ' }.to_sym
    move_pc(from, to, movement)
  end

  def select_pc(from)
    selected_pc = @model.select_pc(from)
    @model.find_movement(selected_pc, from)
  end

  def move_pc(from, to, movement)
    @model.move_pc(from, to, movement)
  end

  def checkmate?
    @model.checkmate?
  end

  def save_game
    @model.save_game
  end
end

ctrl = Controller.start
ctrl.play
