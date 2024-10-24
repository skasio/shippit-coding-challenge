# frozen_string_literal: true

require_relative 'person'

class Family
  attr_reader :mother, :father, :children

  def initialize(mother = NilPerson.new, father = NilPerson.new, children = [])
    raise ArgumentError, 'Mother must be female' if !mother.is_a?(NilPerson) && mother.gender != Gender::FEMALE
    raise ArgumentError, 'Father must be male' if !father.is_a?(NilPerson) && father.gender != Gender::MALE

    @mother = mother
    @father = father
    @children = children
  end

  def assign_mother(mother)
    raise ArgumentError, 'Mother must be female' if mother.gender != Gender::FEMALE

    @mother = mother
  end

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
