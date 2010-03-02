class AddPrivateToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :private, :boolean, :default => true
  end

  def self.down
    remove_column :projects, :private
  end
end
