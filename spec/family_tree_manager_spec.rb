# frozen_string_literal: true

require_relative '../lib/family_tree_manager'

RSpec.describe FamilyTreeManager do
  let(:family_tree_manager) { FamilyTreeManager.instance }
  let(:family_tree) { instance_double(FamilyTree) }

  before do
    family_tree_manager.instance_variable_set(:@family_tree, family_tree)
  end

  describe '#initialize' do
    it 'creates a family tree' do
      expect(family_tree_manager.instance_variable_get(:@family_tree)).to eq(family_tree)
    end
  end

  describe '#add_child' do
    it 'is defined' do
      expect(family_tree_manager).to respond_to(:add_child)
    end

    it 'calls add_child on the family tree' do
      expect(family_tree).to receive(:add_child).with('Child', 'Mother', 'Father')
      family_tree_manager.add_child('Child', 'Mother', 'Father')
    end
  end

  describe '#query_hierarchy' do
    it 'is defined' do
      expect(family_tree_manager).to respond_to(:query_hierarchy)
    end
  end
end
