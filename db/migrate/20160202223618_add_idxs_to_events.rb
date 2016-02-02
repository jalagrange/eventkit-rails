class AddIdxsToEvents < ActiveRecord::Migration
  def change
    add_index :events, :event
    add_index :events, :created_at
    add_index :events, :category

  end
end
