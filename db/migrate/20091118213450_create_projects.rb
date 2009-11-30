class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :title
      t.references :creator
      t.timestamps
    end
    
    add_index :projects, :creator_id
  end
  
  def self.down
    drop_table :projects
  end
end
