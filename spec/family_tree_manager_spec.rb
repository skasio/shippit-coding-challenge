# frozen_string_literal: true

require_relative '../lib/family_tree_manager'

RSpec.describe FamilyTreeManager do
  let(:family_tree_manager) { FamilyTreeManager.instance }

  describe '#initialize' do
    it 'initialises the family_members hash' do
      expect(family_tree_manager.instance_variable_get(:@family_members)).to eq({})
    end
  end

  describe '#add_child' do
    it 'is defined' do
      expect(family_tree_manager).to respond_to(:add_child)
    end
  end

  describe '#query_hierarchy' do
    it 'is defined' do
      expect(family_tree_manager).to respond_to(:query_hierarchy)
    end
  end
end
