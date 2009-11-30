class CreateHashtagships < ActiveRecord::Migration
  def self.up
    create_table :hashtagships do |t|
      t.references :hashtag
      t.references :task

      t.timestamps
    end
    
    add_index :hashtagships, :hashtag_id
    add_index :hashtagships, :task_id
  end

  def self.down
    drop_table :hashtagships
  end
end
