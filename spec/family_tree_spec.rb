# frozen_string_literal: true

require_relative '../lib/family_tree'

RSpec.describe FamilyTree do
  describe '#initialize' do
    it 'creates an empty array' do
      family_tree = FamilyTree.new
      expect(family_tree.instance_variable_get(:@people)).to eq([])
    end
  end

  describe '#add_child' do
    it 'is defined' do
      family_tree = FamilyTree.new
      expect(family_tree).to respond_to(:add_child)
    end

    it 'prints the params' do
      family_tree = FamilyTree.new
      expect do
        family_tree.add_child('Child', 'Mother', 'Father')
      end.to output("Adding Child with params: Child, Mother, Father\n").to_stdout
    end
  end

  describe '#query_hierarchy' do
    it 'is defined' do
      family_tree = FamilyTree.new
      expect(family_tree).to respond_to(:query_hierarchy)
    end

    it 'prints the params' do
      family_tree = FamilyTree.new
      expect do
        family_tree.query_hierarchy('Child')
      end.to output("Querying Hierarcy with params: Child\n").to_stdout
    end
  end
end
