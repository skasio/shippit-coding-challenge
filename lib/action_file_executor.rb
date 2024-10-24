# frozen_string_literal: true

class ActionFileExecutor
  def initialize(file_path)
    @file_path = file_path
    validate_file
  end

  def execute_actions
    File.open(@file_path, 'r') do |file|
      file.each_line do |line|
        action, *params = line.split(' ')
        puts "Executing action: #{action} with params: #{params.join(', ')}"
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
