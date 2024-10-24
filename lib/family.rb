# frozen_string_literal: true

require_relative 'person'

# Family class representing a family unit with a mother, father, and children.
class Family
  attr_reader :mother, :father, :children

  # Initializes a new Family object.
  #
  # @param mother [Person, NilPerson] The mother of the family, defaults to NilPerson.
  # @param father [Person, NilPerson] The father of the family, defaults to NilPerson.
  # @param children [Array<Person>] The children of the family, defaults to an empty array.
  # @raise [ArgumentError] if the mother is not female or the father is not male.
  def initialize(mother = NilPerson.new, father = NilPerson.new, children = [])
    raise ArgumentError, 'Mother must be female' if !mother.is_a?(NilPerson) && mother.gender != Gender::FEMALE
    raise ArgumentError, 'Father must be male' if !father.is_a?(NilPerson) && father.gender != Gender::MALE

    @mother = mother
    @father = father
    @children = children
  end

  # Assigns a new mother to the family.
  #
  # @param mother [Person] The new mother.
  # @raise [ArgumentError] if the mother is not female.
  # @return [void]
  def assign_mother(mother)
    raise ArgumentError, 'Mother must be female' if mother.gender != Gender::FEMALE

    @mother = mother
  end

  # Assigns a new father to the family.
  #
  # @param father [Person] The new father.
  # @raise [ArgumentError] if the father is not male.
  # @return [void]
  def assign_father(father)
    raise ArgumentError, 'Father must be male' if father.gender != Gender::MALE

    @father = father
  end

  def add_child(child)
    @children << child unless @children.include?(child)
  end

  def get_siblings(person)
    @children.reject { |child| child == person }
  end

  def to_s
    mother_str = mother.is_a?(NilPerson) ? 'UNKNOWN' : mother.name
    father_str = father.is_a?(NilPerson) ? 'UNKNOWN' : father.name
    children_str = children.empty? ? 'NONE' : children.map(&:name).join(', ')
    "Family: Mother: #{mother_str}, Father: #{father_str}, Children: #{children_str}"
  end
end
