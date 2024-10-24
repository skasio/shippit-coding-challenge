# frozen_string_literal: true

require 'singleton'

require_relative 'family_tree'

class FamilyTreeManager
  include Singleton

  def initialize
    @family_tree = FamilyTree.new
  end

  def add_child(*params)
    @family_tree.add_child(*params)
  end

  def query_hierarchy(*params)
    @family_tree.query_hierarchy(*params)
  end
end
