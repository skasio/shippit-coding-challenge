# frozen_string_literal: true

require_relative 'action_file_executor'

# CLI class to handle command-line interface operations.
class CLI
  # Initializes the CLI with command-line arguments.
  #
  # @param args [Array<String>] The command-line arguments.
  def initialize(args)
    @args = args
    validate_arguments
  end

  # Runs the CLI, executing actions from the provided file.
  #
  # @return [void]
  def run
    file_path = @args[0]
    action_file_executor = ActionFileExecutor.new(file_path)
    action_file_executor.execute_actions
  end

  private

  # Validates the command-line arguments.
  #
  # @return [void]
  # @raise [SystemExit] if no arguments are provided or the file does not exist.
  def validate_arguments
    if @args.empty?
      puts 'Usage: family_tree <path/to/actions.txt>'
      puts 'Please provide the path to the actions file.'
      exit 1
    end

    file_path = @args[0]
    return if File.exist?(file_path)

    puts "Error: The file '#{file_path}' does not exist."
    exit 1
  end
end
