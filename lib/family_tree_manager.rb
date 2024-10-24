# frozen_string_literal: true

require 'singleton'

class FamilyTreeManager
  include Singleton

  def initialize
    @family_members = {}
  end

  def add_child(*params); end
  def query_hierarchy(*params); end
end
