# == Schema Information
#
# Table name: hashtagships
#
#  id         :integer         not null, primary key
#  hashtag_id :integer
#  task_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Hashtagship < ActiveRecord::Base
  belongs_to :hashtag, :counter_cache => :tasks_count
  belongs_to :task
  after_destroy { |record| record.hashtag.destroy if record.hashtag.tasks_count == 1 }
end