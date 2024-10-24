# frozen_string_literal: true

require 'singleton'

class FamilyTreeManager
  include Singleton

  def initialize
    @family_members = {}
  end

  def add_child(*params)
    puts "Adding Child with params: #{params.join(', ')}"
  end

  def query_hierarchy(*params)
    puts "Querying Hierarcy with params: #{params.join(', ')}"
  end
end
