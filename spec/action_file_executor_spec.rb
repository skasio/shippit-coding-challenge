# frozen_string_literal: true

require 'tempfile'
require_relative '../lib/action_file_executor'
require_relative '../lib/family_tree_manager'

RSpec.describe ActionFileExecutor do
  let(:invalid_file_path) { 'non_existent_file.txt' }
  let(:family_tree_manager) { instance_double('FamilyTreeManager') }
  let(:tempfile) { Tempfile.new('actions.txt') }

  before do
    allow(FamilyTreeManager).to receive(:instance).and_return(family_tree_manager)
    allow(family_tree_manager).to receive(:add_child)
    allow(family_tree_manager).to receive(:query_hierarchy)
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
        tempfile.puts('ADD_CHILD Mother Child Male')
        tempfile.rewind

        action_file_executor = ActionFileExecutor.new(tempfile.path)
        expect(action_file_executor).to be_an_instance_of(ActionFileExecutor)
      end
    end
  end

  describe '#execute_actions' do
    context 'with valid actions' do
      before do
        tempfile.puts('ADD_CHILD Mother Child Male')
        tempfile.puts('GET_RELATIONSHIP Child Maternal-Uncle')
        tempfile.rewind
      end

      it 'calls the add_child method on FamilyTreeManager when it encounters the ADD_CHILD action' do
        action_file_executor = ActionFileExecutor.new(tempfile.path)
        action_file_executor.execute_actions
        expect(family_tree_manager).to have_received(:add_child).with('Mother', 'Child', 'Male')
      end

      it 'calls the query_hierarchy method on FamilyTreeManager when it encounters the GET_RELATIONSHIP action' do
        action_file_executor = ActionFileExecutor.new(tempfile.path)
        action_file_executor.execute_actions
        expect(family_tree_manager).to have_received(:query_hierarchy).with('Child', 'Maternal-Uncle')
      end
    end

    context 'with unsupported actions' do
      before do
        tempfile.puts('ADD_MOTHER Child Mother')
        tempfile.rewind
      end

      it 'prints an error message when it encounters an unsupported action' do
        expect do
          action_file_executor = ActionFileExecutor.new(tempfile.path)
          action_file_executor.execute_actions
        end.to output("Ignoring unsupported action: [ADD_MOTHER]\n").to_stdout
      end
    end
  end
end
