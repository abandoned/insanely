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
  belongs_to :user
  belongs_to :workmate, :class_name => 'User'
  
  include AASM
  aasm_column :status
  aasm_state :requested
  aasm_state :pending
  aasm_state :active
  aasm_event :activate do
    transitions :to => :active, :from => [:pending]
  end
  
  attr_accessible :user, :workmate
end
