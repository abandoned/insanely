# == Schema Information
#
# Table name: readerships
#
#  id         :integer         not null, primary key
#  task_id    :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Readership < ActiveRecord::Base
  belongs_to :readable, :polymorphic => true
  belongs_to :user
end
