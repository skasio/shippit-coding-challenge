# frozen_string_literal: true

require_relative 'nil_person'

# Person class representing an individual with a name, gender, and spouse.
class Person
  attr_accessor :name, :gender, :spouse

  # Initializes a new Person object.
  #
  # @param name [String] The name of the person.
  # @param gender [String] The gender of the person.
  # @param spouse [Person, NilPerson] The spouse of the person, defaults to NilPerson.
  def initialize(name, gender, spouse = NilPerson.new)
    @name = name
    @gender = gender
    @spouse = spouse
  end

  # Returns a string representation of the Person.
  #
  # @return [String] The string representation in the format "name (gender)".
  def to_s
    "#{name} (#{gender})"
  end
end
