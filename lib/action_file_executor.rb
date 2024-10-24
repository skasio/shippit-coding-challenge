# frozen_string_literal: true

require_relative 'family_tree'

class ActionFileExecutor
  def initialize(file_path)
    @file_path = file_path
    validate_file!
  end

  def execute_actions
    File.foreach(@file_path) do |line|
      process_line(line.strip)
    end
  end

  private

  def validate_file!
    return if File.exist?(@file_path)

    abort("Error: The file '#{@file_path}' does not exist.")
  end

  def process_line(line)
    return if line.empty? || comment?(line)

    action, params = extract_action_and_params(line)

    return unless action && valid_action?(action, params)

    execute_action(action, params)
  end

  def comment?(line)
    line.start_with?('#')
  end

  def extract_action_and_params(line)
    match = line.match(/^(\S+)(.*)$/)
    return unless match

    action = match[1]
    params = match[2].scan(/"([^"]+)"|(\S+)/).flatten.compact
    params.map! { |param| param&.strip }
    [action, params]
  end

  def execute_action(action, params)
    case action
    when 'ADD_CHILD'
      puts FamilyTree.instance.add_child(*params)
    when 'GET_RELATIONSHIP'
      puts FamilyTree.instance.get_relationship(*params)
    end
  end

  def valid_action?(action, params)
    case action
    when 'ADD_CHILD' then params.size == 3
    when 'GET_RELATIONSHIP' then params.size == 2
    else false # Ignore unsupported actions
    end
  end
end
