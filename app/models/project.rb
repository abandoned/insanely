# == Schema Information
#
# Table name: projects
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  creator_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class Project < ActiveRecord::Base
  belongs_to :creator, :class_name => 'User'
  has_many :participations, :dependent => :destroy
  has_many :participants, :through => :participations
  has_many :tasks, :order => '"tasks".updated_at DESC', :dependent => :destroy
  has_many :hashtags, :order => '"hashtags".title', :dependent => :destroy
  has_many :readerships, :as => :readable, :dependent => :destroy
  
  validates_uniqueness_of :title, :scope => :creator_id, :message => 'must be unique'
  
  after_create :creator_participates_in_project
  
  attr_accessible :title
  
  private
  
  def creator_participates_in_project
    if attribute_present?('creator_id')
      self.participations.create!(:participant => self.creator)
    end
  end
end
