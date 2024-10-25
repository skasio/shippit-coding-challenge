# frozen_string_literal: true

require_relative '../lib/family_tree'
require_relative '../lib/person'
require_relative '../lib/family'

RSpec.describe FamilyTree do
  let(:mother) { Person.new('Jane', Gender::FEMALE) }
  let(:father) { Person.new('John', Gender::MALE) }
  let(:child1) { Person.new('Anna', Gender::FEMALE) }
  let(:child2) { Person.new('Bob', Gender::MALE) }
  let(:child3) { Person.new('Charlie', Gender::MALE) }
  let(:maternal_aunt) { Person.new('Alice', Gender::FEMALE) }
  let(:paternal_aunt) { Person.new('Catherine', Gender::FEMALE) }
  let(:maternal_uncle) { Person.new('Mark', Gender::MALE) }
  let(:paternal_uncle) { Person.new('David', Gender::MALE) }

  let(:family) { Family.new(mother, father, [child1, child2]) }

  before do
    FamilyTree.instance.families.clear
    FamilyTree.instance.add_family(Family.new(NilPerson.new, NilPerson.new, [mother, maternal_aunt, maternal_uncle]))
    FamilyTree.instance.add_family(Family.new(NilPerson.new, NilPerson.new, [father, paternal_aunt, paternal_uncle]))
    FamilyTree.instance.add_family(family)
  end

  describe '#add_family' do
    it 'adds a family to the family list' do
      expect(FamilyTree.instance.families).to include(family)
    end

    it 'does not add a duplicate family' do
      expect { FamilyTree.instance.add_family(family) }.not_to(change { FamilyTree.instance.families.count })
    end
  end

  describe '#add_child' do
    context 'when the mother is present' do
      it 'successfully adds a child to the family' do
        result = FamilyTree.instance.add_child(mother.name, 'Charlie', Gender::MALE)
        expect(result).to eq('CHILD_ADDED')
        expect(family.children.last.name).to eq('Charlie')
      end

      it 'does not add a duplicate child' do
        FamilyTree.instance.add_child(mother.name, 'Charlie', Gender::MALE)
        result = FamilyTree.instance.add_child(mother.name, 'Charlie', Gender::MALE)
        expect(result).to eq('CHILD_ADDITION_FAILED')
        expect(family.children.count { |child| child.name.casecmp('Charlie').zero? }).to eq(1)
      end
    end

    context 'when the mother is not present' do
      it 'fails to add a child and returns PERSON_NOT_FOUND' do
        FamilyTree.instance.families.clear # Clear existing families
        result = FamilyTree.instance.add_child('Unknown Mother', 'Charlie', Gender::MALE)
        expect(result).to eq('PERSON_NOT_FOUND')
      end
    end
  end

  describe '#get_relationship' do
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

    context 'finding children' do
      it 'returns all children when queried' do
        expect(FamilyTree.instance.get_relationship(father.name, 'child')).to eq("#{child1.name} #{child2.name}")
      end

      it 'returns only sons when queried' do
        FamilyTree.instance.add_child(mother.name, 'Charlie', Gender::MALE)
        expect(FamilyTree.instance.get_relationship(father.name, 'son')).to eq("#{child2.name} Charlie")
      end

      it 'returns only daughters when queried' do
        expect(FamilyTree.instance.get_relationship(father.name, 'daughter')).to eq(child1.name)
      end

      it 'returns NONE if there are no children' do
        single_child_family = Family.new(mother, father, [])
        FamilyTree.instance.families.clear
        FamilyTree.instance.add_family(single_child_family)

        expect(FamilyTree.instance.get_relationship(father.name, 'child')).to eq('NONE')
      end
    end

    context 'finding aunts and uncles' do
      it 'returns maternal aunts' do
        expect(FamilyTree.instance.get_relationship(child1.name, 'maternal-aunt')).to eq(maternal_aunt.name)
      end

      it 'returns paternal aunts' do
        expect(FamilyTree.instance.get_relationship(child1.name, 'paternal-aunt')).to eq(paternal_aunt.name)
      end

      it 'returns maternal uncles' do
        expect(FamilyTree.instance.get_relationship(child1.name, 'maternal-uncle')).to eq(maternal_uncle.name)
      end

      it 'returns paternal uncles' do
        expect(FamilyTree.instance.get_relationship(child1.name, 'paternal-uncle')).to eq(paternal_uncle.name)
      end
    end

    # TODO: Add tests for finding in-laws
    context 'finding in-laws' do
      it 'returns sister-in-law' do; end

      it 'returns brother-in-law' do; end
    end

    context 'invalid relationships' do
      it 'returns false for unsupported types' do
        expect(FamilyTree.instance.get_relationship('Anna', 'uncle')).to eq(false)
      end
    end
  end
end
