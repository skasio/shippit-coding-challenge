# frozen_string_literal: true

require 'singleton'
require_relative 'person'
require_relative 'family_factory'

# FamilyTree class representing a family tree.
# This class follows the Singleton pattern to ensure there is only one instance
# of the family tree throughout the application. It uses the FamilyFactory to
# seed the initial family tree with predefined families.
class FamilyTree
  include Singleton

  attr_accessor :families

  # Initializes the FamilyTree instance.
  # Seeds the initial family tree using the FamilyFactory.
  def initialize
    @families = FamilyFactory.new.create_families
  end

  # Adds a family to the family tree.
  #
  # @param family [Family] The family to add.
  # @return [void]
  def add_family(family)
    @families << family unless @families.include?(family)
  end

  # Adds a child to a family based on the mother's name.
  #
  # @param mothers_name [String] The name of the mother.
  # @param name [String] The name of the child.
  # @param gender [String] The gender of the child.
  # @return [String] 'CHILD_ADDED' if the child is added successfully, 'CHILD_ADDITION_FAILED' otherwise.
  def add_child(mothers_name, name, gender)
    result = find_person_in_families(mothers_name)
    parent = result[:person]
    parent_of_family = result[:parent_of_family]

    return 'PERSON_NOT_FOUND' if parent.is_a?(NilPerson)

    if parent_of_family.nil? || parent_of_family.mother.is_a?(NilPerson) || parent_of_family.father.eql?(parent)
      return 'CHILD_ADDITION_FAILED'
    end

    return 'CHILD_ADDITION_FAILED' if parent_of_family.children.any? { |child| child.name.casecmp(name).zero? }

    child = Person.new(name, gender)
    parent_of_family.add_child(child)
    'CHILD_ADDED'
  end

  # Retrieves the relationship of a person based on their name and the specified relationship.
  #
  # @param name [String] The name of the person.
  # @param relationship [String] The type of relationship to retrieve.
  # @return [String] The name(s) of the related person(s) or an appropriate message if not found.
  def get_relationship(name, relationship)
    result = find_person_in_families(name)
    person = result[:person]
    parent_of_family = result[:parent_of_family]
    child_of_family = result[:child_of_family]

    return 'PERSON_NOT_FOUND' if person.is_a?(NilPerson)

    case relationship.downcase
    when 'mother', 'father'
      handle_parent_relationship(child_of_family, relationship)
    when 'siblings', 'sibling'
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
      false
    end
  end

  private

  # Handles the parent relationship retrieval.
  #
  # @param child_of_family [Family] The family of the child.
  # @param relationship [String] The type of parent relationship ('mother' or 'father').
  # @return [String] The name of the parent or 'PERSON_NOT_FOUND' if not found.
  def handle_parent_relationship(child_of_family, relationship)
    parent = relationship == 'mother' ? child_of_family&.mother : child_of_family&.father
    return 'PERSON_NOT_FOUND' if parent.nil? || parent.is_a?(NilPerson)

    parent.name
  end

  # Handles the siblings relationship retrieval.
  #
  # @param child_of_family [Family] The family of the child.
  # @param name [String] The name of the child.
  # @return [String] The names of the siblings or 'NONE' if not found.
  def handle_siblings_relationship(child_of_family, name)
    siblings = find_siblings(child_of_family, name)
    siblings.empty? ? 'NONE' : siblings.map(&:name).join(' ')
  end

  # Handles the children relationship retrieval.
  #
  # @param parent_of_family [Family] The family of the parent.
  # @param relationship [String] The type of children relationship ('child', 'son', or 'daughter').
  # @return [String] The names of the children or 'NONE' if not found.
  def handle_children_relationship(parent_of_family, relationship)
    return 'NONE' if parent_of_family.nil?

    children = parent_of_family.children

    case relationship.downcase
    when 'child'
      children.empty? ? 'NONE' : children.map(&:name).join(' ')
    when 'son'
      sons = children.select { |child| child.gender == Gender::MALE }
      sons.empty? ? 'NONE' : sons.map(&:name).join(' ')
    when 'daughter'
      daughters = children.select { |child| child.gender == Gender::FEMALE }
      daughters.empty? ? 'NONE' : daughters.map(&:name).join(' ')
    else
      false
    end
  end

  # Handles the sibling relationship retrieval for uncles and aunts.
  #
  # @param child_of_family [Family] The family of the child.
  # @param type [String] The type of sibling relationship ('uncle' or 'aunt').
  # @param side [String] The side of the family ('paternal' or 'maternal').
  # @return [String] The names of the uncles or aunts or 'NONE' if not found.
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

  # Handles the uncle relationship retrieval.
  #
  # @param child_of_family [Family] The family of the child.
  # @param type [String] The type of uncle relationship ('paternal' or 'maternal').
  # @return [String] The names of the uncles or 'NONE' if not found.
  def handle_uncle_relationship(child_of_family, type)
    handle_sibling_relationship(child_of_family, 'uncle', type)
  end

  # Handles the aunt relationship retrieval.
  #
  # @param child_of_family [Family] The family of the child.
  # @param type [String] The type of aunt relationship ('paternal' or 'maternal').
  # @return [String] The names of the aunts or 'NONE' if not found.
  def handle_aunt_relationship(child_of_family, type)
    handle_sibling_relationship(child_of_family, 'aunt', type)
  end

  # Handles the sister-in-law relationship retrieval.
  #
  # @param person [Person] The person whose sister-in-law is to be found.
  # @param child_of_family [Family] The family of the child.
  # @return [String] The names of the sisters-in-law or 'NONE' if not found.
  def handle_sister_in_law_relationship(person, child_of_family)
    find_in_laws(person, child_of_family, Gender::FEMALE)
  end

  # Handles the brother-in-law relationship retrieval.
  #
  # @param person [Person] The person whose brother-in-law is to be found.
  # @param child_of_family [Family] The family of the child.
  # @return [String] The names of the brothers-in-law or 'NONE' if not found.
  def handle_brother_in_law_relationship(person, child_of_family)
    find_in_laws(person, child_of_family, Gender::MALE)
  end

  # Finds the in-laws of a person based on their gender.
  #
  # @param person [Person] The person whose in-laws are to be found.
  # @param child_of_family [Family] The family of the child.
  # @param gender [String] The gender of the in-laws to find.
  # @return [String] The names of the in-laws or 'NONE' if not found.
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

  # Finds a person in the families by name.
  #
  # @param name [String] The name of the person to find.
  # @return [Hash] A hash containing the person, parent_of_family, and child_of_family.
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

  # Finds the siblings of a person in a family.
  #
  # @param family [Family] The family of the person.
  # @param name [String] The name of the person.
  # @return [Array<Person>] An array of siblings.
  def find_siblings(family, name)
    family.children.reject { |child| child.name.casecmp(name).zero? }
  end

  # Checks if a person is a child of a family.
  #
  # @param family [Family] The family to check.
  # @param name [String] The name of the person.
  # @return [Boolean] True if the person is a child of the family, false otherwise.
  def child_of_family?(family, name)
    return false unless family.is_a?(Family)

    family.children.any? do |child|
      child.name.casecmp(name).zero?
    end
  end
end
