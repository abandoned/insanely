class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.references :project
      t.references :author
      t.string :message
      t.string :status
      t.integer :comments_count, :default => 0
      t.timestamps
    end
    
    add_index :tasks, :project_id
    add_index :tasks, :author_id
    add_index :tasks, :message
  end
  
  def self.down
    drop_table :tasks
  end
end
