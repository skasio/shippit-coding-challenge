# frozen_string_literal: true

require 'tempfile'
require_relative '../lib/action_file_executor'

RSpec.describe ActionFileExecutor do
  let(:tempfile) { Tempfile.new('actions.txt') }
  let(:invalid_file_path) { 'non_existent_file.txt' }

  before do
    tempfile.write('ADD_CHILD Mother Child Male')
    tempfile.rewind
  end

  after do
    tempfile.close
    tempfile.unlink
  end

  describe '#initialize' do
    context 'when the file does not exist' do
      it 'prints an error message and exits' do
        expect do
          ActionFileExecutor.new(invalid_file_path)
        end.to output("Error: The file 'non_existent_file.txt' does not exist.\n").to_stdout.and raise_error(SystemExit)
      end
    end

    context 'when the file exists' do
      it 'initializes successfully' do
        action_file_executor = ActionFileExecutor.new(tempfile.path)
        expect(action_file_executor).to be_an_instance_of(ActionFileExecutor)
      end
    end
  end

  describe '#execute_actions' do
    it 'prints message indicating action being executed and the parameters which were passed' do
      action_file_executor = ActionFileExecutor.new(tempfile.path)
      expect do
        action_file_executor.execute_actions
      end.to output("Executing action: ADD_CHILD with params: Mother, Child, Male\n").to_stdout
    end
  end
end
