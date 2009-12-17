# == Schema Information
#
# Table name: tasks
#
#  id             :integer         not null, primary key
#  project_id     :integer
#  author_id      :integer
#  message        :string(255)
#  status         :string(255)
#  comments_count :integer         default(0)
#  created_at     :datetime
#  updated_at     :datetime
#

class Task < ActiveRecord::Base
  include AASM
  
  validates_length_of :message, :maximum => 255
  validates_length_of :message, :minimum => 1,
    :unless => Proc.new{|s| s.assets.size > 0 }
  
  belongs_to :project,  :touch => true
  belongs_to :author,   :class_name => "User"
  
  has_many :comments
  has_many :hashtagships
  has_many :hashtags,     :through => :hashtagships
  has_many :assignments
  has_many :assignees,    :through => :assignments, :class_name => 'User'
  has_many :assets, :as => :attachable, :dependent => :delete_all
  has_many :readerships, :as => :readable, :dependent => :destroy
  
  after_save    :reload_associations
  after_destroy :reload_associations
  
  attr_accessible :message, :assets_attributes
  
  accepts_nested_attributes_for :assets, :allow_destroy => true, :reject_if => proc { |attributes| attributes['file'].blank? }
  
  named_scope :assigned_to, proc { |user|
    {
      :joins => :assignments,
      :conditions => ['assignments.assignee_id = ?', user.id]
    }
  }
  named_scope :query, proc { |query|
    {
      :include => [:comments],
      :conditions => ['UPPER(tasks.message) LIKE ? OR UPPER(comments.message) LIKE ?', "%#{query.upcase}%", "%#{query.upcase}%"]
    } 
  }
  
  named_scope :most_recent, :order => 'updated_at DESC', :limit => 1
  
  aasm_column         :status
  aasm_initial_state  :active
  aasm_state          :active
  aasm_state          :iceboxed
  aasm_state          :completed
  
  aasm_event :icebox do
    transitions :to => :iceboxed, :from => [:active]
  end
  
  aasm_event :complete do
    transitions :to => :completed, :from => [:active, :iceboxed]
  end
  
  aasm_event :uncomplete do
    transitions :to => :active, :from => [:completed]
  end
  
  aasm_event :defrost do
    transitions :to => :active, :from => [:iceboxed]
  end
  
  def not_active?
    self.completed? || self.iceboxed? || self.frozen?
  end
  
  private
  
  def reload_associations
    all_msg(true)
    reload_tags
    reload_assignments
  end
  
  # These reload methods get called multiple times when the task has attachments,
  # which end up "touching" back whenever the task is edited etc. Must be a cleaner
  # way of doing this. For now, I deal with the situation with the nil? checks.
  def reload_tags
    if self.not_active?
      self.hashtagships.destroy_all
    else
      old_hashtags = self.hashtags.collect { |h| h.title } || []
      new_hashtags = parse_messages(/#([a-z0-9_]+)/i)
      new_hashtags = ['untitled'] if new_hashtags.blank?
      
      # Destroy obsolete hashtagships
      (old_hashtags - new_hashtags).each do |t|
        hashtag = self.hashtags.find_by_title(t)
        self.hashtagships.find_by_hashtag_id(hashtag.id).destroy unless hashtag.nil?
      end
      
      # Create new hashtagships
      new_hashtags.each do |t|
        hashtag = self.project.hashtags.find_or_create_by_title(t)
        self.hashtags << hashtag unless self.hashtags.include?(hashtag)
      end
    end
  end
  
  def reload_assignments
    if self.completed? || self.iceboxed? || self.frozen?
      self.assignments.destroy_all
    else
      old_assignees = self.assignees.collect { |a| a.login } || []
      new_assignees = parse_messages(/\B@([a-z0-9._]+)/i) -
                      parse_messages(/\B-@([a-z0-9._]+)/i)
      
      # Destroy obsolete assignments
      (old_assignees - new_assignees).each do |a|
        assignee = self.assignees.find_by_login(a)
        self.assignments.find_by_assignee_id(assignee.id).destroy unless assignee.nil?
      end
      
      # Create new assignments
      (new_assignees - old_assignees).each do |a|
        assignee = self.project.participants.find_by_login(a)
        unless assignee.nil?
          self.assignees << assignee
        end
      end
    end
  end
  
  def parse_messages(regex)
    all_msg.scan(regex).collect{ |m| m.to_s.downcase }.uniq
  end
  
  def all_msg(reload=false)
    @all_msg = nil if reload
    @all_msg ||= self.comments.inject([self.message]){ |m, c| m << c.message }.join(' ')
  end
end
