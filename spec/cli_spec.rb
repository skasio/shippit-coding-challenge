# frozen_string_literal: true

require_relative '../lib/cli'

RSpec.describe CLI do
  let(:valid_file_path) { 'test_actions.txt' }
  let(:invalid_file_path) { 'non_existent_file.txt' }

  before do
    File.write(valid_file_path, 'some actions')
  end

  after do
    File.delete(valid_file_path) if File.exist?(valid_file_path)
  end

  describe '#initialize' do
    context 'when no arguments are provided' do
      it 'prints usage message and exits' do
        expect do
          CLI.new([])
        end.to output(%r{Usage: family_tree <path/to/actions.txt>}).to_stdout.and raise_error(SystemExit)
      end
    end

    context 'when an invalid file path is provided' do
      it 'prints error message and exits' do
        expect do
          CLI.new([invalid_file_path])
        end.to output(/Error: The file 'non_existent_file.txt' does not exist./).to_stdout.and raise_error(SystemExit)
      end
    end

    context 'when a valid file path is provided' do
      it 'initializes successfully' do
        cli = CLI.new([valid_file_path])
        expect(cli).to be_an_instance_of(CLI)
      end
    end
  end
end
