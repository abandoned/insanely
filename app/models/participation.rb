# == Schema Information
#
# Table name: participations
#
#  id             :integer         not null, primary key
#  project_id     :integer
#  participant_id :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class Participation < ActiveRecord::Base
  belongs_to :participant, :class_name => "User"
  belongs_to :project
  
  validates_uniqueness_of :participant_id, :scope => :project_id
  validates_associated :participant
  validates_presence_of :participant
  
  attr_accessible :participant
end
