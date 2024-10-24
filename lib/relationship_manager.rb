# frozen_string_literal: true

require 'singleton'

# RelationshipManager class to manage relationships between people.
# This class follows the Singleton pattern to ensure there is only one instance
# of the relationship manager throughout the application.
class RelationshipManager
  include Singleton

  # Links two people as spouses.
  #
  # @param person1 [Person] The first person to link.
  # @param person2 [Person] The second person to link.
  # @raise [RuntimeError] if either person is already linked to someone else.
  # @return [void]
  def link_spouses(person1, person2)
    # Check if either person is already linked to someone else
    if person1.spouse != NilPerson.new && person1.spouse != person2
      raise "Cannot link #{person1.name} and #{person2.name}: #{person1.name} is already linked to #{person1.spouse.name}."
    end

    if person2.spouse != NilPerson.new && person2.spouse != person1
      raise "Cannot link #{person1.name} and #{person2.name}: #{person2.name} is already linked to #{person2.spouse.name}."
    end

    # Link the spouses
    person1.spouse = person2
    person2.spouse = person1 unless person2.is_a?(NilPerson)
  end
end
