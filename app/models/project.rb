# == Schema Information
#
# Table name: projects
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  creator_id  :integer
#  created_at  :datetime
#  updated_at  :datetime
#  status      :string(255)     default("active")
#  description :string(255)
#

class Project < ActiveRecord::Base
  include AASM
  
  belongs_to :creator, :class_name => 'User'
  has_many :participations, :dependent => :destroy
  has_many :participants, :through => :participations
  has_many :tasks, :order => '"tasks".updated_at DESC', :dependent => :destroy
  has_many :hashtags, :order => '"hashtags".title', :dependent => :destroy
  has_many :readerships, :as => :readable, :dependent => :destroy
  
  validates_uniqueness_of :title, :scope => :creator_id, :message => 'must be unique'
  
  after_create :creator_participates_in_project
  
  attr_accessible :title, :description
  
  aasm_column         :status
  aasm_initial_state  :active
  aasm_state          :active
  aasm_state          :archived
  
  aasm_event :archive do
    transitions :to => :archived, :from => [:active]
  end
  
  aasm_event :unarchive do
    transitions :to => :active, :from => [:archived]
  end
  
  private
  
  def creator_participates_in_project
    if attribute_present?('creator_id')
      self.participations.create!(:participant => self.creator)
    end
  end
end

