class AddIdxToSchoolIdInEventSchoolRelationships < ActiveRecord::Migration
  def change
    add_index :event_school_relationships, :school_id
  end
end
