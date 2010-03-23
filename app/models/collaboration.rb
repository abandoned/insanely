# == Schema Information
#
# Table name: collaborations
#
#  id          :integer         not null, primary key
#  user_id     :integer
#  workmate_id :integer
#  status      :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Collaboration < ActiveRecord::Base
  include AASM
  
  belongs_to :user
  belongs_to :workmate, :class_name => 'User'
  
  
  aasm_column :status
  aasm_initial_state :requested
  aasm_state :requested
  aasm_state :pending
  aasm_state :active
  aasm_event :activate do
    transitions :to => :active, :from => [:pending, :requested]
  end
  
  attr_accessible :user, :workmate, :status
end
