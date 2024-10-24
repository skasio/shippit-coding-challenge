# frozen_string_literal: true

class CLI
  def initialize(args)
    @args = args
    validate_arguments
  end

  def run
    file_path = @args[0]
    puts "Running actions from file: #{file_path} against the family tree."
  end

  private

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
