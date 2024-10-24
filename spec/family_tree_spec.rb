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

  before do
    # Reset FamilyTree singleton before each test
    FamilyTree.instance.families.clear
  end

  describe '#add_family' do
    it 'adds a family to the family list' do
      FamilyTree.instance.add_family(family)
      expect(FamilyTree.instance.families).to include(family)
    end

    it 'does not add a duplicate family' do
      FamilyTree.instance.add_family(family)
      FamilyTree.instance.add_family(family)
      expect(FamilyTree.instance.families.count).to eq(1)
    end
  end

  describe '#add_child' do
    before do
      FamilyTree.instance.add_family(family)
    end

    context 'when the mother is present' do
      it 'adds a child to the family' do
        result = FamilyTree.instance.add_child(mother.name, 'Charlie', Gender::FEMALE)
        expect(result).to eq('CHILD_ADDED')
        expect(family.children.last.name).to eq('Charlie')
      end

      it 'does not add a duplicate child' do
        FamilyTree.instance.add_child(mother.name, 'Charlie', Gender::FEMALE)
        result = FamilyTree.instance.add_child(mother.name, 'Charlie', Gender::FEMALE)
        expect(result).to eq('CHILD_ADDITION_FAILED')
        expect(family.children.count { |child| child.name.casecmp('Charlie').zero? }).to eq(1)
      end
    end

    context 'when the mother is not present' do
      it 'returns CHILD_ADDITION_FAILED' do
        FamilyTree.instance.families.clear # Remove existing families
        result = FamilyTree.instance.add_child('Unknown Mother', 'Charlie', Gender::FEMALE)
        expect(result).to eq('CHILD_ADDITION_FAILED')
      end
    end
  end

  describe '#get_relationship' do
    before do
      FamilyTree.instance.add_family(family)
    end

    context 'when finding mother' do
      it 'returns the mother if present' do
        result = FamilyTree.instance.get_relationship('Anna', 'mother')
        expect(result).to eq(mother.name)
      end

      it 'returns PERSON_NOT_FOUND if the person has no mother' do
        orphan_family = Family.new(NilPerson.new, father, [child1])
        FamilyTree.instance.families.clear
        FamilyTree.instance.add_family(orphan_family)

        result = FamilyTree.instance.get_relationship('Anna', 'mother')
        expect(result).to eq('PERSON_NOT_FOUND')
      end
    end

    context 'when finding father' do
      it 'returns father\'s name if present' do
        result = FamilyTree.instance.get_relationship('Anna', 'father')
        expect(result).to eq(father.name)
      end

      it 'returns PERSON_NOT_FOUND if the person has no father' do
        orphan_family = Family.new(mother, NilPerson.new, [child1])
        FamilyTree.instance.families.clear
        FamilyTree.instance.add_family(orphan_family)

        result = FamilyTree.instance.get_relationship('Anna', 'father')
        expect(result).to eq('PERSON_NOT_FOUND')
      end
    end

    context 'when finding siblings' do
      it 'returns the sibling\'s name if present' do
        result = FamilyTree.instance.get_relationship('Anna', 'siblings')
        expect(result).to eq(child2.name)
      end

      it 'returns NONE if there are no siblings' do
        single_child_family = Family.new(mother, father, [child1])
        FamilyTree.instance.families.clear
        FamilyTree.instance.add_family(single_child_family)

        result = FamilyTree.instance.get_relationship('Anna', 'siblings')
        expect(result).to eq('NONE')
      end
    end

    context 'when relationship type is invalid' do
      it 'returns UNSUPPORTED_RELATIONSHIP' do
        result = FamilyTree.instance.get_relationship('Anna', 'uncle')
        expect(result).to eq('UNSUPPORTED_RELATIONSHIP')
      end
    end
  end
end
