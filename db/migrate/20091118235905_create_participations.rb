class CreateParticipations < ActiveRecord::Migration
  def self.up
    create_table :participations do |t|
      t.references :project
      t.references :participant
      
      t.timestamps
    end
    
    add_index :participations, :project_id
    add_index :participations, :participant_id
  end

  def self.down
    drop_table :participations
  end
end
