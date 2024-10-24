# frozen_string_literal: true

require_relative '../lib/cli'

# Initializes and runs the CLI with the provided arguments.
#
# @param [Array<String>] ARGV the command-line arguments passed to the script
CLI.new(ARGV).run
