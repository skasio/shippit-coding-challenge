# frozen_string_literal: true

require_relative 'family_tree_manager'

class ActionFileExecutor
  def initialize(file_path)
    @file_path = file_path
    validate_file
  end

  def execute_actions
    File.open(@file_path, 'r') do |file|
      file.each_line do |line|
        action, *params = line.split(' ')
        case action
        when 'ADD_CHILD'
          FamilyTreeManager.instance.add_child(*params)
        when 'GET_RELATIONSHIP'
          FamilyTreeManager.instance.query_hierarchy(*params)
        else
          puts "Ignoring unsupported action: [#{action}]"
        end
      end
    end
  end

  private

  def validate_file
    return if File.exist?(@file_path)

    puts "Error: The file '#{@file_path}' does not exist."
    exit 1
  end
end
