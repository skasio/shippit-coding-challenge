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
      expect { FamilyTree.instance.add_family(family) }.not_to(change { FamilyTree.instance.families.count })
    end
  end

  describe '#add_child' do
    before { FamilyTree.instance.add_family(family) }

    context 'when the mother is present' do
      it 'successfully adds a child to the family' do
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
      it 'fails to add a child and returns CHILD_ADDITION_FAILED' do
        FamilyTree.instance.families.clear # Clear existing families
        result = FamilyTree.instance.add_child('Unknown Mother', 'Charlie', Gender::FEMALE)
        expect(result).to eq('CHILD_ADDITION_FAILED')
      end
    end
  end

  describe '#get_relationship' do
    before { FamilyTree.instance.add_family(family) }

    context 'finding parents' do
      it 'returns the mother\'s name if present' do
        expect(FamilyTree.instance.get_relationship('Anna', 'mother')).to eq(mother.name)
      end

      it 'returns the father\'s name if present' do
        expect(FamilyTree.instance.get_relationship('Anna', 'father')).to eq(father.name)
      end

      it 'returns PERSON_NOT_FOUND if the person has no mother' do
        orphan_family = Family.new(NilPerson.new, father, [child1])
        FamilyTree.instance.families.clear
        FamilyTree.instance.add_family(orphan_family)

        expect(FamilyTree.instance.get_relationship('Anna', 'mother')).to eq('PERSON_NOT_FOUND')
      end

      it 'returns PERSON_NOT_FOUND if the person has no father' do
        orphan_family = Family.new(mother, NilPerson.new, [child1])
        FamilyTree.instance.families.clear
        FamilyTree.instance.add_family(orphan_family)

        expect(FamilyTree.instance.get_relationship('Anna', 'father')).to eq('PERSON_NOT_FOUND')
      end
    end

    context 'finding siblings' do
      it 'returns sibling\'s name if present' do
        expect(FamilyTree.instance.get_relationship('Anna', 'siblings')).to eq(child2.name)
      end

      it 'returns NONE if there are no siblings' do
        single_child_family = Family.new(mother, father, [child1])
        FamilyTree.instance.families.clear
        FamilyTree.instance.add_family(single_child_family)

        expect(FamilyTree.instance.get_relationship('Anna', 'siblings')).to eq('NONE')
      end
    end

    context 'invalid relationships' do
      it 'returns UNSUPPORTED_RELATIONSHIP for unsupported types' do
        expect(FamilyTree.instance.get_relationship('Anna', 'uncle')).to eq('UNSUPPORTED_RELATIONSHIP')
      end
    end
  end
end
