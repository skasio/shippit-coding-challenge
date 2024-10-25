# frozen_string_literal: true

require_relative '../lib/family_tree'
require_relative '../lib/person'
require_relative '../lib/family'

RSpec.describe FamilyTree do
  let(:mother) { Person.new('Jane', Gender::FEMALE) }
  let(:father) { Person.new('John', Gender::MALE) }
  let(:child1) { Person.new('Anna', Gender::FEMALE) }
  let(:child2) { Person.new('Bob', Gender::MALE) }

  let(:family) { Family.new(mother, father, [child1, child2]) }

  describe '#add_family' do
    it 'adds a family to the family list' do
      FamilyTree.instance.add_family(family)
      expect(FamilyTree.instance.families).to include(family)
    end

    it 'does not add a duplicate family' do
      FamilyTree.instance.add_family(family)
      expect { FamilyTree.instance.add_family(family) }.not_to(change { FamilyTree.instance.families.count })
    end
  end

  describe '#add_child' do
    context 'when the mother is present' do
      it 'successfully adds a child to the family and returns CHILD_ADDED' do
        result = FamilyTree.instance.add_child('Queen Margaret', 'Jonathan', Gender::MALE)
        expect(result).to eq('CHILD_ADDED')
      end

      it 'does not add a duplicate child and returns CHILD_ADDITION_FAILED' do
        FamilyTree.instance.add_child('Queen Margaret', 'Charlie', Gender::MALE)
        result = FamilyTree.instance.add_child('Queen Margaret', 'Charlie', Gender::MALE)
        expect(result).to eq('CHILD_ADDITION_FAILED')
      end
    end

    context 'when the mother is not present' do
      it 'fails to add a child and returns PERSON_NOT_FOUND' do
        result = FamilyTree.instance.add_child('Unknown Mother', 'Charlie', Gender::MALE)
        expect(result).to eq('PERSON_NOT_FOUND')
      end
    end
  end

  describe '#get_relationship' do
    context 'finding parents' do
      it 'returns the mother\'s name if present' do
        expect(FamilyTree.instance.get_relationship('Charlie', 'mother')).to eq('Queen Margaret')
      end

      it 'returns the father\'s name if present' do
        expect(FamilyTree.instance.get_relationship('Charlie', 'father')).to eq('King Arthur')
      end

      it 'returns PERSON_NOT_FOUND if the person has no mother' do
        expect(FamilyTree.instance.get_relationship('King Arthur', 'mother')).to eq('PERSON_NOT_FOUND')
      end

      it 'returns PERSON_NOT_FOUND if the person has no father' do
        expect(FamilyTree.instance.get_relationship('Queen Margaret', 'father')).to eq('PERSON_NOT_FOUND')
      end
    end

    context 'finding siblings' do
      it 'returns sibling\'s name if present' do
        expect(FamilyTree.instance.get_relationship('Draco', 'sibling')).to eq('Aster')
        expect(FamilyTree.instance.get_relationship('Draco', 'sibling')).to eq('Aster')
      end

      it 'returns NONE if there are no siblings' do
        expect(FamilyTree.instance.get_relationship('Remus', 'sibling')).to eq('NONE')
        expect(FamilyTree.instance.get_relationship('Remus', 'siblings')).to eq('NONE')
      end
    end

    context 'finding children' do
      it 'returns all children when queried' do
        expect(FamilyTree.instance.get_relationship('Percy', 'child')).to eq('Molly Lucy')
      end

      it 'returns only sons when queried' do
        expect(FamilyTree.instance.get_relationship('Alice', 'son')).to eq('Ron')
      end

      it 'returns only daughters when queried' do
        expect(FamilyTree.instance.get_relationship('Alice', 'daughter')).to eq('Ginny')
      end

      it 'returns NONE if there are no children' do
        expect(FamilyTree.instance.get_relationship('Charlie', 'child')).to eq('NONE')
      end

      it 'returns NONE if there are no sons' do
        expect(FamilyTree.instance.get_relationship('Charlie', 'son')).to eq('NONE')
      end

      it 'returns NONE if there are no daugthers' do
        expect(FamilyTree.instance.get_relationship('Charlie', 'daughter')).to eq('NONE')
      end
    end
  end

  context 'finding aunts and uncles' do
    it 'returns maternal aunts' do
      expect(FamilyTree.instance.get_relationship('Remus', 'maternal-aunt')).to eq('Dominique')
    end

    it 'returns paternal aunts' do
      expect(FamilyTree.instance.get_relationship('William', 'paternal-aunt')).to eq('Lily')
    end

    it 'returns maternal uncles' do
      expect(FamilyTree.instance.get_relationship('Aster', 'maternal-uncle')).to eq('Hugo')
    end

    it 'returns paternal uncles' do
      expect(FamilyTree.instance.get_relationship('Ginny', 'paternal-uncle')).to eq('James')
    end
  end

  context 'finding in-laws' do
    it 'returns sister-in-law via spouse' do
      expect(FamilyTree.instance.get_relationship('Alice', 'sister-in-law')).to eq('Lily')
    end

    it 'returns sister-in-law via sibling' do
      expect(FamilyTree.instance.get_relationship('Percy', 'sister-in-law')).to eq('Flora Helen')
    end

    it 'returns brother-in-law via spouse' do
      expect(FamilyTree.instance.get_relationship('Malfoy', 'brother-in-law')).to eq('Hugo')
    end

    it 'returns brother-in-law via sibling' do
      expect(FamilyTree.instance.get_relationship('Percy', 'brother-in-law')).to eq('Harry')
    end
  end

  context 'invalid relationships' do
    it 'returns false for unsupported types' do
      expect(FamilyTree.instance.get_relationship('King Arthur', 'pet')).to eq(false)
    end
  end
end
