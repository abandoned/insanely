class MakeReadershipPolymorphic < ActiveRecord::Migration
  def self.up
    rename_column :readerships, :task_id, :readable_id
    add_column :readerships, :readable_type, :string
    add_index :readerships, :readable_type
  end

  def self.down
    remove_index :readerships, :readable_type
    remove_column :readerships, :readable_type
    rename_column :readerships, :readable_id, :task_id
  end
end
