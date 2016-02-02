class AddAdditionalIdxToEvents < ActiveRecord::Migration
  def change
    add_index :events, [:event, :category, :created_at]
  end
end
