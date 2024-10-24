# frozen_string_literal: true

class Gender
  MALE = 'male'
  FEMALE = 'female'

  def self.all
    [MALE, FEMALE]
  end

  def self.valid?(gender)
    return false unless gender.is_a?(String)

    all.include?(gender.downcase)
  end
end
