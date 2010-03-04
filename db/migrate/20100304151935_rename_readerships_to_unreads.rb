class RenameReadershipsToUnreads < ActiveRecord::Migration
  def self.up
    rename_table 'readerships', 'unreads'
    add_column :unreads, :project_id, :integer
    add_index :unreads, :readable_id
    add_index :unreads, :project_id
  end

  def self.down
    rename_table 'unreads', 'readerships'
    remove_column :readerships, :project_id
    remove_index :readerships, :readable_id
    remove_index :readerships, :project_id
  end
end
