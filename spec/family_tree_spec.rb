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
    it 'outputs the correct parameters when adding a child' do
      expect do
        FamilyTree.instance.add_child('Jane', 'Sam',
                                      'Male')
      end.to output("Adding Child with params: Jane, Sam, Male\n").to_stdout
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

  describe '#find_mother' do
    it 'returns the mother if present' do
      expect(FamilyTree.instance.find_mother(family)).to eq(mother)
    end

    it 'returns NilPerson if no mother is present' do
      orphan_family = Family.new(NilPerson.new, father, [child1])
      expect(FamilyTree.instance.find_mother(orphan_family)).to be_a(NilPerson)
    end
  end

  describe '#find_father' do
    it 'returns the father if present' do
      expect(FamilyTree.instance.find_father(family)).to eq(father)
    end

    it 'returns NilPerson if no father is present' do
      orphan_family = Family.new(mother, NilPerson.new, [child1])
      expect(FamilyTree.instance.find_father(orphan_family)).to be_a(NilPerson)
    end
  end

  describe '#find_siblings' do
    it 'returns siblings in the same family' do
      result = FamilyTree.instance.find_siblings(family, 'Anna')
      expect(result).to eq([child2])
    end

    it 'returns empty array if there are no siblings' do
      single_child_family = Family.new(mother, father, [child1])
      result = FamilyTree.instance.find_siblings(single_child_family, 'Anna')
      expect(result).to eq([])
    end
  end

  describe '#child_of_family?' do
    it 'returns true if the person is a child of the family' do
      expect(FamilyTree.instance.child_of_family?(family, 'Anna')).to be true
    end

    it 'returns false if the person is not a child of the family' do
      expect(FamilyTree.instance.child_of_family?(family, 'Unknown')).to be false
    end
  end
end
