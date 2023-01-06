# frozen_string_literal: true

require 'yaml'
require 'fileutils'

# This module handles saving files
#
module Savable
  def save_game
    save(to_yaml)
  end

  def save(data)
    file_dir = "saved_files/#{@w_player.name}_#{@b_player.name}.yml"
    FileUtils.mkdir_p('saved_files')
    File.open(file_dir, 'w') { |file| file.puts data }
  end

  def to_yaml
    obj = {}
    instance_variables.map { |var| obj[var.to_s.delete('@')] = instance_variable_get(var) }
    YAML.dump(obj)
  end
end
