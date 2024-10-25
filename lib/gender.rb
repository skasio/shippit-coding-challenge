# frozen_string_literal: true

# Gender class to handle gender-related operations.
class Gender
  MALE = 'male'
  FEMALE = 'female'

  # Returns all defined genders.
  #
  # @return [Array<String>] An array of all genders.
  def self.all
    [MALE, FEMALE]
  end

  # Checks if the provided gender is valid.
  #
  # @param gender [String] The gender to validate.
  # @return [Boolean] True if the gender is valid, false otherwise.
  def self.valid?(gender)
    return false unless gender.is_a?(String)

    all.include?(gender.downcase)
  end
end
