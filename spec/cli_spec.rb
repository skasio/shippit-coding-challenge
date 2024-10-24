# frozen_string_literal: true

require 'tempfile'
require_relative '../lib/cli'

RSpec.describe CLI do
  let(:tempfile) { Tempfile.new('actions.txt') }
  let(:invalid_file_path) { 'non_existent_file.txt' }
  let(:action_file_executor) { instance_double('ActionFileExecutor') }
  let(:args) { [tempfile.path] }

  before do
    allow(ActionFileExecutor).to receive(:new).with(tempfile.path).and_return(action_file_executor)
    allow(action_file_executor).to receive(:execute_actions)
  end

  after do
    tempfile.close
    tempfile.unlink
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
        cli = CLI.new([tempfile.path])
        expect(cli).to be_an_instance_of(CLI)
      end
    end
  end

  describe '#run' do
    it 'creates an ActionFileExecutor and executes actions' do
      cli = CLI.new(args)
      cli.run

      expect(ActionFileExecutor).to have_received(:new).with(tempfile.path)
      expect(action_file_executor).to have_received(:execute_actions)
    end
  end
end
