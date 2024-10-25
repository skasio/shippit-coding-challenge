# frozen_string_literal: true

require_relative 'family_tree'

# ActionFileExecutor class to handle the execution of actions from a file.
# This class processes each line of the file, extracts actions and their parameters,
# and executes the corresponding actions. It handles both quoted and unquoted parameters.
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

  # Processes a line from the action file.
  # Extracts the action and parameters, and executes the action if valid.
  #
  # @param line [String] The line to process.
  # @return [void]
  def process_line(line)
    return if comment?(line)

    action, params = extract_action_and_params(line)
    return unless action && valid_action?(action, params)

    execute_action(action, params)
  end

  # Checks if a line is a comment.
  #
  # @param line [String] The line to check.
  # @return [Boolean] True if the line is a comment, false otherwise.
  def comment?(line)
    line.start_with?('#')
  end

  # Extracts the action and parameters from a line.
  # Handles both quoted and unquoted parameters.
  #
  # @param line [String] The line to extract from.
  # @return [Array<String, Array<String>>] An array containing the action and parameters.
  def extract_action_and_params(line)
    match = line.match(/^(\S+)(.*)$/)
    return unless match

    action = match[1]
    params = match[2].scan(/"([^"]+)"|(\S+)/).flatten.compact
    params.map! { |param| param&.strip }
    [action, params]
  end

  # Executes the action with the given parameters.
  #
  # @param action [String] The action to execute.
  # @param params [Array<String>] The parameters for the action.
  # @return [void]
  def execute_action(action, params)
    case action
    when 'ADD_CHILD'
      puts FamilyTree.instance.add_child(*params)
    when 'GET_RELATIONSHIP'
      result = FamilyTree.instance.get_relationship(*params)
      result && puts(result)
    end
  end

  # Validates the action and its parameters.
  #
  # @param action [String] The action to validate.
  # @param params [Array<String>] The parameters to validate.
  # @return [Boolean] True if the action and parameters are valid, false otherwise.
  def valid_action?(action, params)
    case action
    when 'ADD_CHILD' then params.size == 3
    when 'GET_RELATIONSHIP' then params.size == 2
    else false # Ignore unsupported actions
    end
  end
end
