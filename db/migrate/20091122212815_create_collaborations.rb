class CreateCollaborations < ActiveRecord::Migration
  def self.up
    create_table :collaborations do |t|
      t.references :user
      t.references :workmate
      t.string :status
      
      t.timestamps
    end
    
    add_index :collaborations, :user_id
    add_index :collaborations, :workmate_id
  end

  def self.down
    drop_table :collaborations
  end
end
