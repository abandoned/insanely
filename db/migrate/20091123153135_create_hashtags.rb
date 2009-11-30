class CreateHashtags < ActiveRecord::Migration
  def self.up
    create_table :hashtags do |t|
      t.references :project
      t.integer :tasks_count
      t.string :title

      t.timestamps
    end
    
    add_index :hashtags, :project_id
  end

  def self.down
    drop_table :hashtags
  end
end
