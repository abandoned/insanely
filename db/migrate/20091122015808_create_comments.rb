class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.references :task
      t.references :author
      t.text :message
      t.timestamps
    end
    
    add_index :comments, :task_id
    add_index :comments, :author_id
    add_index :comments, :message
  end
  
  def self.down
    drop_table :comments
  end
end
