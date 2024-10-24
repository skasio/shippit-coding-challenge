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

  # Checks equality with another object.
  #
  # @param other [Object] The object to compare with.
  # @return [Boolean] True if the other object is a Person with the same name, gender, and spouse, false otherwise.
  def ==(other)
    other.is_a?(Person) && name == other.name && gender == other.gender && spouse == other.spouse
  end

  # Checks equality with another object (alias for ==).
  #
  # @param other [Object] The object to compare with.
  # @return [Boolean] True if the other object is a Person with the same name, gender, and spouse, false otherwise.
  def eql?(other)
    self == other
  end

  # Computes the hash code for the Person object.
  #
  # @return [Integer] The hash code based on the name, gender, and spouse.
  def hash
    [name, gender, spouse].hash
  end

  # Returns a string representation of the Person.
  #
  # @return [String] The string representation in the format "name (gender)".
  def to_s
    "#{name} (#{gender})"
  end
end
