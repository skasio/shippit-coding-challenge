# frozen_string_literal: true

require_relative 'family'
require_relative 'person'
require_relative 'gender'

# FamilyFactory class to create initial families for the FamilyTree.
# The primary purpose of this class is to create and initialize predefined families.
class FamilyFactory
  # Initializes a new FamilyFactory object.
  # Sets up a hash to store people and gets the singleton instance of RelationshipManager.
  def initialize
    @people = {}
  end

  # Creates and returns an array of predefined families.
  #
  # @return [Array<Family>] An array of predefined Family objects.
  def create_families
    [
      create_queen_margaret_and_king_arthur_family,
      create_flora_and_bill_family,
      create_victoire_and_ted_family,
      create_percy_and_audrey_family,
      create_ronald_and_helen_family,
      create_malfoy_and_rose_family,
      create_ginerva_and_harry_family,
      create_darcy_and_james_family,
      create_alice_and_albus_family
    ]
  end

  private

  # Finds or creates a person with the given name and gender.
  #
  # @param name [String] The name of the person.
  # @param gender [String] The gender of the person.
  # @return [Person] The found or created Person object.
  def find_or_create_person(name, gender)
    return @people[name] if @people.key?(name)

    person = Person.new(name, gender)
    @people[name] = person
    person
  end

  # Finds or creates a male person with the given name.
  #
  # @param name [String] The name of the male person.
  # @return [Person] The found or created male Person object.
  def find_or_create_male(name)
    find_or_create_person(name, Gender::MALE)
  end

  # Finds or creates a female person with the given name.
  #
  # @param name [String] The name of the female person.
  # @return [Person] The found or created female Person object.
  def find_or_create_female(name)
    find_or_create_person(name, Gender::FEMALE)
  end

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

  # Creates the family of Queen Margaret and King Arthur.
  #
  # @return [Family] The created Family object.
  def create_queen_margaret_and_king_arthur_family
    queen_margaret = find_or_create_female('Queen Margaret')
    king_arthur = find_or_create_male('King Arthur')

    link_spouses(queen_margaret, king_arthur)

    bill = find_or_create_male('Bill')
    charlie = find_or_create_male('Charlie')
    percy = find_or_create_male('Percy')
    ronald = find_or_create_male('Ronald')
    ginerva = find_or_create_female('Ginerva')

    Family.new(queen_margaret, king_arthur, [bill, charlie, percy, ronald, ginerva])
  end

  # Creates the family of Flora and Bill.
  #
  # @return [Family] The created Family object.
  def create_flora_and_bill_family
    bill = find_or_create_male('Bill')
    flora = find_or_create_female('Flora')

    link_spouses(flora, bill)

    victoire = find_or_create_female('Victoire')
    dominique = find_or_create_female('Dominique')
    louis = find_or_create_male('Louis')

    Family.new(flora, bill, [victoire, dominique, louis])
  end

  # Creates the family of Victoire and Ted.
  #
  # @return [Family] The created Family object.
  def create_victoire_and_ted_family
    victoire = find_or_create_female('Victoire')
    ted = find_or_create_male('Ted')

    link_spouses(victoire, ted)

    remus = find_or_create_male('Remus')

    Family.new(victoire, ted, [remus])
  end

  # Creates the family of Percy and Audrey.
  #
  # @return [Family] The created Family object.
  def create_percy_and_audrey_family
    percy = find_or_create_male('Percy')
    audrey = find_or_create_female('Audrey')

    link_spouses(audrey, percy)

    molly = find_or_create_female('Molly')
    lucy = find_or_create_female('Lucy')

    Family.new(audrey, percy, [molly, lucy])
  end

  # Creates the family of Ronald and Helen.
  #
  # @return [Family] The created Family object.
  def create_ronald_and_helen_family
    ronald = find_or_create_male('Ronald')
    helen = find_or_create_female('Helen')

    link_spouses(helen, ronald)

    rose = find_or_create_female('Rose')
    hugo = find_or_create_male('Hugo')

    Family.new(helen, ronald, [rose, hugo])
  end

  # Creates the family of Malfoy and Rose.
  #
  # @return [Family] The created Family object.
  def create_malfoy_and_rose_family
    malfoy = find_or_create_male('Malfoy')
    rose = find_or_create_female('Rose')

    link_spouses(rose, malfoy)

    draco = find_or_create_male('Draco')
    aster = find_or_create_female('Aster')

    Family.new(rose, malfoy, [draco, aster])
  end

  # Creates the family of Ginerva and Harry.
  #
  # @return [Family] The created Family object.
  def create_ginerva_and_harry_family
    ginerva = find_or_create_female('Ginerva')
    harry = find_or_create_male('Harry')

    link_spouses(ginerva, harry)

    james = find_or_create_male('James')
    albus = find_or_create_male('Albus')
    lily = find_or_create_female('Lily')

    Family.new(ginerva, harry, [james, albus, lily])
  end

  # Creates the family of Darcy and James.
  #
  # @return [Family] The created Family object.
  def create_darcy_and_james_family
    darcy = find_or_create_female('Darcy')
    james = find_or_create_male('James')

    link_spouses(darcy, james)

    william = find_or_create_male('William')

    Family.new(darcy, james, [william])
  end

  # Creates the family of Alice and Albus.
  #
  # @return [Family] The created Family object.
  def create_alice_and_albus_family
    alice = find_or_create_female('Alice')
    albus = find_or_create_male('Albus')

    link_spouses(alice, albus)

    ron = find_or_create_male('Ron')
    ginny = find_or_create_female('Ginny')

    Family.new(alice, albus, [ron, ginny])
  end
end
