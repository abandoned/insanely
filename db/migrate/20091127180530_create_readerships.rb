class CreateReaderships < ActiveRecord::Migration
  def self.up
    create_table :readerships do |t|
      t.references :task
      t.references :user

      t.timestamps
    end
    
    add_index :readerships, :task_id
    add_index :readerships, :user_id
  end

  def self.down
    drop_table :readerships
  end
end
