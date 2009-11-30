# == Schema Information
#
# Table name: assignments
#
#  id          :integer         not null, primary key
#  assignee_id :integer
#  task_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Assignment < ActiveRecord::Base
  belongs_to :assignee, :class_name => 'User'
  belongs_to :task
end
