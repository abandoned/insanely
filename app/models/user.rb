# == Schema Information
#
# Table name: users
#
#  id                  :integer         not null, primary key
#  login               :string(255)
#  email               :string(255)
#  crypted_password    :string(255)
#  password_salt       :string(255)
#  persistence_token   :string(255)
#  single_access_token :string(255)
#  perishable_token    :string(255)
#  login_count         :integer
#  failed_login_count  :integer
#  last_request_at     :datetime
#  current_login_at    :datetime
#  last_login_at       :datetime
#  current_login_ip    :string(255)
#  last_login_ip       :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#

class User < ActiveRecord::Base
  acts_as_authentic
  is_gravtastic!
  
  has_many :created_projects, :class_name => 'Project', :foreign_key => 'creator_id'
  has_many :participations, :foreign_key => 'participant_id', :dependent => :destroy
  has_many :projects, :through => :participations, :order => 'projects.updated_at DESC'
  has_many :collaborations, :dependent => :destroy
  has_many :workmates, :through => :collaborations
  has_many :pending_workmates, :through => :collaborations, :source => :user, :conditions => 'collaborations.status = "pending"'
  has_many :posts, :dependent => :destroy
  has_many :assignments, :foreign_key => 'assignee_id'
  has_many :assigned_tasks, :through => :assignments, :source => :task
  has_many :readerships, :dependent => :destroy
  
  attr_accessible :login, :email, :password, :password_confirmation
  
  def active?
    self.active
  end

  def deliver_password_reset_instructions!  
    reset_perishable_token!  
    Notifier.send_later(:deliver_password_reset_instructions, self)
  end
end
