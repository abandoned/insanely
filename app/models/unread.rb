class Unread < ActiveRecord::Base
  belongs_to :readable, :polymorphic => true
  belongs_to :user
  belongs_to :project
end

# == Schema Information
#
# Table name: unreads
#
#  id            :integer         not null, primary key
#  readable_id   :integer
#  user_id       :integer
#  created_at    :datetime
#  updated_at    :datetime
#  readable_type :string(255)
#  project_id    :integer
#

