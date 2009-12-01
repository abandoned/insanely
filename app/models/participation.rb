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
  
  attr_accessible :participant
end
