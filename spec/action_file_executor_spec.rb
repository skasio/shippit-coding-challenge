# frozen_string_literal: true

require 'tempfile'
require_relative '../lib/action_file_executor'

RSpec.describe ActionFileExecutor do
  let(:invalid_file_path) { 'non_existent_file.txt' }
  let(:family_tree) { instance_double('FamilyTree') }
  let(:tempfile) { Tempfile.new('actions.txt') }

  before do
    allow(FamilyTree).to receive(:instance).and_return(family_tree)
    allow(family_tree).to receive(:add_child)
    allow(family_tree).to receive(:get_relationship).and_return([])
  end

  after do
    tempfile.close
    tempfile.unlink
  end

  describe '#initialize' do
    context 'when the file exists' do
      it 'initializes successfully' do
        action_file_executor = ActionFileExecutor.new(tempfile.path)
        expect(action_file_executor).to be_an_instance_of(ActionFileExecutor)
      end
    end

    context 'when the file does not exist' do
      it 'prints an error message and exits' do
        expect do
          ActionFileExecutor.new(invalid_file_path)
        end.to output("Error: The file 'non_existent_file.txt' does not exist.\n").to_stderr.and raise_error(SystemExit)
      end
    end
  end

  describe '#execute_actions' do
    context 'with a valid file' do
      before do
        tempfile.write("ADD_CHILD \"Mother's Name\" \"Child's Name\" Male\n")
        tempfile.write("# A comment\n")
        tempfile.write("\n")
        tempfile.write("INVALID ACTION\n")
        tempfile.write("GET_RELATIONSHIP \"Mother's Name\" \"Son\"\n")
        tempfile.rewind
      end

      it 'processes all lines in the file' do
        action_file_executor = ActionFileExecutor.new(tempfile.path)
        allow(action_file_executor).to receive(:process_line)

        action_file_executor.execute_actions
        expect(action_file_executor).to have_received(:process_line).exactly(5).times
      end

      it 'executes actions for non-empty and non-comment lines' do
        action_file_executor = ActionFileExecutor.new(tempfile.path)
        allow(action_file_executor).to receive(:execute_action)

        action_file_executor.execute_actions
        expect(action_file_executor).to have_received(:execute_action).exactly(2).times
      end
    end
  end

  describe '#process_line' do
    context 'with a comment line' do
      it 'does not execute the action' do
        action_file_executor = ActionFileExecutor.new(tempfile.path)
        expect(action_file_executor.send(:process_line, '# This is a comment')).to be_nil
      end
    end

    context 'with an empty line' do
      it 'does not execute the action' do
        action_file_executor = ActionFileExecutor.new(tempfile.path)
        expect(action_file_executor.send(:process_line, '')).to be_nil
      end
    end
  end

  describe '#extract_action_and_params' do
    it 'returns the action and params from the line' do
      action_file_executor = ActionFileExecutor.new(tempfile.path)
      expect(action_file_executor.send(:extract_action_and_params,
                                       'ADD_CHILD "Mother\'s Name" "Child\'s Name"')).to eq(['ADD_CHILD',
                                                                                             ["Mother's Name",
                                                                                              "Child's Name"]])
    end
  end

  describe '#execute_action' do
    context 'with the ADD_CHILD action' do
      it 'calls the add_child method on FamilyTree' do
        action_file_executor = ActionFileExecutor.new(tempfile.path)
        action_file_executor.send(:execute_action, 'ADD_CHILD', ["Mother's Name", "Child's Name", 'Male'])
        expect(family_tree).to have_received(:add_child).with("Mother's Name", "Child's Name", 'Male')
      end
    end

    context 'with the GET_RELATIONSHIP action' do
      it 'calls the get_relationship method on FamilyTree' do
        action_file_executor = ActionFileExecutor.new(tempfile.path)
        action_file_executor.send(:execute_action, 'GET_RELATIONSHIP', ["Mother's Name", 'Son'])
        expect(family_tree).to have_received(:get_relationship).with("Mother's Name", 'Son')
      end
    end

    context 'with an unsupported action' do
      it 'does nothing' do
        action_file_executor = ActionFileExecutor.new(tempfile.path)
        expect do
          action_file_executor.send(:execute_action, 'ADD_MOTHER', ["Child's Name", "Mother's Name"])
        end.not_to raise_error
      end
    end
  end
end
