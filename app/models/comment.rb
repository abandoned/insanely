# == Schema Information
#
# Table name: comments
#
#  id         :integer         not null, primary key
#  task_id    :integer
#  author_id  :integer
#  message    :text
#  created_at :datetime
#  updated_at :datetime
#

class Comment < ActiveRecord::Base
  validates_associated :assets
  
  validates_length_of :message, :minimum => 1,
    :unless => Proc.new{|record| record.assets.size > 0 }
  
  # Setting the dependent option on has_many :assets to destroy triggered a 
  # bug where a blank comment with an asset would not destroy due to failed
  # validation after the asset was deleted.
  
  belongs_to :task, :counter_cache => true, :touch => true
  belongs_to :author, :class_name => 'User'
  has_many :assets, :as => :attachable, :dependent => :delete_all
  has_many :unreads, :as => :readable, :dependent => :destroy
  
  attr_accessible :message, :author, :assets_attributes
  
  accepts_nested_attributes_for :assets, :allow_destroy => true, :reject_if => proc { |attributes| attributes['file'].blank? }
end
