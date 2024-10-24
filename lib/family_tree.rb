# frozen_string_literal: true

require 'singleton'

require_relative 'person'
require_relative 'family_factory'

class FamilyTree
  include Singleton

  attr_accessor :families, :people

  def initialize
    @families = FamilyFactory.new.create_families
    @people = []
  end

  def add_family(family)
    @families << family unless @families.include?(family)
  end

  def add_child(*params)
    puts "Adding Child with params: #{params.join(', ')}"
  end

  def get_relationship(name, relationship)
    family = find_family(name)

    return [] if family.nil?

    if child_of_family?(family, name)
      case relationship.downcase
      when 'mother'
        mother = find_mother(family)
        return mother.is_a?(NilPerson) ? [] : [mother]
      when 'father'
        father = find_father(family)
        return father.is_a?(NilPerson) ? [] : [father]
      when 'siblings'
        return find_siblings(family, name)
      else
        return []
      end
    end

    []
  end

  def find_family(name)
    families.each do |family|
      family.children.each do |child|
        return family if child.name.casecmp(name).zero?
      end
    end
    nil
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
