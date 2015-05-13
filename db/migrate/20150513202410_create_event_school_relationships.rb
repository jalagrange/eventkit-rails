class CreateEventSchoolRelationships < ActiveRecord::Migration
  def change
    create_table :event_school_relationships do |t|
      t.integer :event_id
      t.integer :school_id

      t.timestamps
    end
  end
end
