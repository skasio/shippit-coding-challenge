# frozen_string_literal: true

require_relative '../lib/family'
require_relative '../lib/person'
require_relative '../lib/nil_person'
require_relative '../lib/gender'

RSpec.describe Family do
  describe '#initialize' do
    it 'creates a new family with a mother, father, and children' do
      family = Family.new
      expect(family.mother).to be_a(NilPerson)
      expect(family.father).to be_a(NilPerson)
      expect(family.children).to eq([])
    end

    it 'raises an error if the mother is not a female' do
      jack = Person.new('Jack', Gender::MALE)

      expect { Family.new(jack) }.to raise_error(ArgumentError).with_message('Mother must be female')
    end

    it 'raises an error if the father is not a male' do
      jill = Person.new('Jill', Gender::FEMALE)

      expect { Family.new(NilPerson.new, jill) }.to raise_error(ArgumentError).with_message('Father must be male')
    end
  end

  describe 'assign_mother' do
    it 'raises an error if the mother is not a female' do
      family = Family.new
      jack = Person.new('Jack', Gender::MALE)

      expect { family.assign_mother(jack) }.to raise_error(ArgumentError).with_message('Mother must be female')
    end
  end

  describe 'assign_father' do
    it 'raises an error if the mother is not a female' do
      family = Family.new
      jill = Person.new('Jill', Gender::FEMALE)

      expect { family.assign_father(jill) }.to raise_error(ArgumentError).with_message('Father must be male')
    end
  end

  describe '#add_child' do
    it 'adds a child to the family' do
      family = Family.new
      child = Person

      family.add_child(child)
      expect(family.children).to eq([child])
    end
  end

  describe '#get_siblings' do
    it 'returns all siblings of a person' do
      family = Family.new
      child1 = Person.new('Jack', Gender::MALE)
      child2 = Person.new('Jill', Gender::FEMALE)
      child3 = Person.new('Phil', Gender::MALE)

      family.add_child(child1)
      family.add_child(child2)
      family.add_child(child3)

      expect(family.get_siblings(child1)).to eq([child2, child3])
    end
  end
end
