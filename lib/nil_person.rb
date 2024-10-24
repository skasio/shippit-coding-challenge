# frozen_string_literal: true

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
