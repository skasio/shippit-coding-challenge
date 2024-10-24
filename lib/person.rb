# frozen_string_literal: true

class Person
  attr_accessor :name, :gender, :spouse

  def initialize(name, gender, spouse = NilPerson.new)
    @name = name
    @gender = gender
    @spouse = spouse
  end

  def ==(other)
    other.is_a?(Person) && name == other.name && gender == other.gender && spouse == other.spouse
  end

  def eql?(other)
    self == other
  end

  def hash
    [name, gender, spouse].hash
  end

  def to_s
    "#{name} (#{gender})"
  end
end

class NilPerson
  def name
    nil
  end

  def father
    self
  end

  def mother
    self
  end

  def gender
    nil
  end

  def ==(other)
    other.is_a?(NilPerson)
  end

  def eql?(other)
    self == other
  end

  def to_s
    ''
  end
end
