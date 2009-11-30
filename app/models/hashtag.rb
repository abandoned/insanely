# == Schema Information
#
# Table name: hashtags
#
#  id          :integer         not null, primary key
#  project_id  :integer
#  tasks_count :integer
#  title       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Hashtag < ActiveRecord::Base
  belongs_to :project
  has_many :hashtagships, :dependent => :destroy
  has_many :tasks, :through => :hashtagships
  validates_uniqueness_of :title, :scope => :project_id
end
