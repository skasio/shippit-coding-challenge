# frozen_string_literal: true

# NilPerson class following the NullObject pattern.
# This class represents a null object for a person, providing default
# implementations that return nil or self as appropriate.
class NilPerson
  # Returns the name of the NilPerson.
  #
  # @return [nil] Always returns nil.
  def name
    nil
  end

  # Returns the father of the NilPerson.
  #
  # @return [NilPerson] Always returns self.
  def father
    self
  end

  # Returns the mother of the NilPerson.
  #
  # @return [NilPerson] Always returns self.
  def mother
    self
  end

  # Returns the gender of the NilPerson.
  #
  # @return [nil] Always returns nil.
  def gender
    nil
  end

  # Checks equality with another object.
  #
  # @param other [Object] The object to compare with.
  # @return [Boolean] True if the other object is a NilPerson, false otherwise.
  def ==(other)
    other.is_a?(NilPerson)
  end

  # Checks equality with another object (alias for ==).
  #
  # @param other [Object] The object to compare with.
  # @return [Boolean] True if the other object is a NilPerson, false otherwise.
  def eql?(other)
    self == other
  end

  def to_s
    ''
  end
end
