# frozen_string_literal: true

require_relative 'family_tree'

class ActionFileExecutor
  def initialize(file_path)
    @file_path = file_path
    validate_file
  end

  def execute_actions
    File.open(@file_path, 'r') do |file|
      file.each_line do |line|
        process_line(line.strip)
      end
    end
  end

  private

  def validate_file
    return if File.exist?(@file_path)

    puts "Error: The file '#{@file_path}' does not exist."
    exit 1
  end

  def process_line(line)
    return if line.empty? || comment?(line)

    action, params = extract_action_and_params(line)
    execute_action(action, params) if action
  end

  def comment?(line)
    line.start_with?('#')
  end

  def extract_action_and_params(line)
    match = line.match(/^(\S+)(.*)$/)
    return unless match

    action = match[1]
    params = match[2].scan(/"([^"]+)"|(\S+)/).flatten.compact
    [action, params]
  end

  def execute_action(action, params)
    case action
    when 'ADD_CHILD'
      handle_add_child(*params)
    when 'GET_RELATIONSHIP'
      handle_get_relationship(*params)
    else
      puts "Ignoring unsupported action: [#{action}]"
    end
  end

  def handle_add_child(*params)
    FamilyTree.instance.add_child(*params)
  end

  def handle_get_relationship(*params)
    result = FamilyTree.instance.get_relationship(*params)
    puts result.empty? ? 'NONE' : result.map(&:name).join(', ')
  end
end
