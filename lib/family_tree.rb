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

  def add_child(mothers_name, name, gender)
    result = find_person_in_families(mothers_name)
    parent_of_family = result[:parent_of_family]

    return 'CHILD_ADDITION_FAILED' if parent_of_family.nil? || parent_of_family.mother.is_a?(NilPerson)

    return 'CHILD_ADDITION_FAILED' if parent_of_family.children.any? { |child| child.name.casecmp(name).zero? }

    child = Person.new(name, gender)
    parent_of_family.add_child(child)
    'CHILD_ADDED'
  end

  def get_relationship(name, relationship)
    result = find_person_in_families(name)
    person = result[:person]
    parent_of_family = result[:parent_of_family]
    child_of_family = result[:child_of_family]

    return 'PERSON_NOT_FOUND' if person.is_a?(NilPerson)

    case relationship.downcase
    when 'mother', 'father'
      handle_parent_relationship(child_of_family, relationship)
    when 'siblings'
      handle_siblings_relationship(child_of_family, name)
    when 'child', 'daughter', 'son'
      handle_children_relationship(parent_of_family, relationship)
    when 'paternal-uncle'
      handle_uncle_relationship(child_of_family, 'paternal')
    when 'maternal-uncle'
      handle_uncle_relationship(child_of_family, 'maternal')
    when 'paternal-aunt'
      handle_aunt_relationship(child_of_family, 'paternal')
    when 'maternal-aunt'
      handle_aunt_relationship(child_of_family, 'maternal')
    when 'sister-in-law'
      handle_sister_in_law_relationship(person, child_of_family)
    when 'brother-in-law'
      handle_brother_in_law_relationship(person, child_of_family)
    else
      'UNSUPPORTED_RELATIONSHIP'
    end
  end

  private

  def handle_parent_relationship(child_of_family, relationship)
    parent = relationship == 'mother' ? child_of_family&.mother : child_of_family&.father
    return 'PERSON_NOT_FOUND' if parent.nil? || parent.is_a?(NilPerson)

    parent.name
  end

  def handle_siblings_relationship(child_of_family, name)
    siblings = find_siblings(child_of_family, name)
    siblings.empty? ? 'NONE' : siblings.map(&:name).join(' ')
  end

  def handle_children_relationship(parent_of_family, relationship)
    return 'NONE' if parent_of_family.nil?

    children = parent_of_family.children

    case relationship.downcase
    when 'child'
      children.map(&:name).join(' ')
    when 'son'
      sons = children.select { |child| child.gender == Gender::MALE }
      sons.empty? ? 'NONE' : sons.map(&:name).join(' ')
    when 'daughter'
      daughters = children.select { |child| child.gender == Gender::FEMALE }
      daughters.empty? ? 'NONE' : daughters.map(&:name).join(' ')
    else
      'UNSUPPORTED_RELATIONSHIP'
    end
  end

  def handle_sibling_relationship(child_of_family, type, side)
    return 'NONE' if child_of_family.nil?

    parent = side == 'paternal' ? child_of_family.father : child_of_family.mother
    return 'NONE' if parent.nil? || parent.is_a?(NilPerson)

    # Find the family where the parent is a child
    parent_result = find_person_in_families(parent.name)
    parent_family = parent_result[:child_of_family]

    return 'NONE' if parent_family.nil?

    # Find the siblings of the parent
    siblings = find_siblings(parent_family, parent.name)

    # Select based on sibling gender
    relatives = case type
                when 'uncle'
                  siblings.select { |sibling| sibling.gender == Gender::MALE }
                when 'aunt'
                  siblings.select { |sibling| sibling.gender == Gender::FEMALE }
                else
                  []
                end

    relatives.empty? ? 'NONE' : relatives.map(&:name).join(' ')
  end

  def handle_uncle_relationship(child_of_family, type)
    handle_sibling_relationship(child_of_family, 'uncle', type)
  end

  def handle_aunt_relationship(child_of_family, type)
    handle_sibling_relationship(child_of_family, 'aunt', type)
  end

  def handle_sister_in_law_relationship(person, child_of_family)
    find_in_laws(person, child_of_family, Gender::FEMALE)
  end

  def handle_brother_in_law_relationship(person, child_of_family)
    find_in_laws(person, child_of_family, Gender::MALE)
  end

  def find_in_laws(person, child_of_family, gender)
    in_laws = []

    # Check for siblings of the spouse
    if person.spouse.is_a?(Person)
      spouse_result = find_person_in_families(person.spouse.name)
      spouse_family = spouse_result[:child_of_family]

      if spouse_family
        spouse_siblings = find_siblings(spouse_family, person.spouse.name)
        in_laws.concat(spouse_siblings.select { |sibling| sibling.gender == gender }.map(&:name))
      end
    end

    unless child_of_family.nil?
      # Check for spouses of siblings of the person
      siblings = find_siblings(child_of_family, person.name)

      siblings.each do |sibling|
        in_laws << sibling.spouse.name if sibling.spouse && sibling.spouse.gender == gender
      end
    end

    in_laws.uniq!
    in_laws.empty? ? 'NONE' : in_laws.join(' ')
  end

  def find_person_in_families(name)
    result = { person: NilPerson.new, parent_of_family: nil, child_of_family: nil }

    families.each do |family|
      # Check for mother
      if family.mother&.name&.casecmp(name)&.zero?
        result[:person] = family.mother
        result[:parent_of_family] = family
      end

      # Check for father
      if family.father&.name&.casecmp(name)&.zero?
        result[:person] = family.father
        result[:parent_of_family] = family
      end

      family.children.each do |child|
        next if child.nil? || child.name.nil?

        if child.name.casecmp(name).zero? && family != result[:parent_of_family]
          result[:person] = child
          result[:child_of_family] = family
        end
      end
    end

    result
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
