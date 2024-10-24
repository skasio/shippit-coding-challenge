# frozen_string_literal: true

require 'singleton'

require_relative 'person'
require_relative 'family_factory'

class FamilyTree
  include Singleton

  attr_accessor :families

  def initialize
    @families = FamilyFactory.new.create_families
  end

  def add_family(family)
    @families << family unless @families.include?(family)
  end

  def add_child(*params)
    puts "Adding Child with params: #{params.join(', ')}"
  end

  def get_relationship(name, relationship)
    result = find_person_and_family(name)
    person = result[:person]
    family = result[:family]

    return 'PERSON_NOT_FOUND' if family.nil? || person.is_a?(NilPerson)

    case relationship.downcase
    when 'mother'
      mother = find_mother(family)
      return 'PERSON_NOT_FOUND' if mother.is_a?(NilPerson)

      mother.name
    when 'father'
      father = find_father(family)
      return 'PERSON_NOT_FOUND' if father.is_a?(NilPerson)

      father.name
    when 'siblings'
      siblings = find_siblings(family, name)
      siblings.empty? ? 'NONE' : siblings.map(&:name).join(' ')
    else
      'UNSUPPORTED_RELATIONSHIP'
    end
  end

  def find_person_and_family(name)
    families.each do |family|
      family.children.each do |child|
        return { person: child, family: family } if child.name.casecmp(name).zero?
      end
    end
    { person: NilPerson.new, family: nil }
  end

  def find_mother(family)
    mother = family.mother
    mother || NilPerson.new
  end

  def find_father(family)
    father = family.father
    father || NilPerson.new
  end

  def find_siblings(family, name)
    family.children.reject { |child| child.name.casecmp(name).zero? }
  end

  def child_of_family?(family, name)
    return false unless family.is_a?(Family)

    family.children.any? do |child|
      child.name.casecmp(name).zero?
    end
  end
end
