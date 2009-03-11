

class RelationshipDetails < ActiveRecord::Base
  set_table_name "relationship_details"
  has_many :relationships, {:dependent => true}

  def other_relationship(first_relationship)
    relationships[0] unless relationships[0] == first_relationship
    relationships[1] unless relationships[1] == first_relationship
  end

end
