desc "Migrate"
task :migrate => :environment do
  
  class RemoteTask < ActiveResource::Base
    self.site = 'http://insane.ly/'
    #self.site = 'http://localhost:3000'
    self.element_name = 'task'
  end
  
  Task.record_timestamps = false
  Comment.record_timestamps = false
  
  project = Project.find(1)
  users = [
    { :id => 1, :api_key => '1'},
    { :id => 2, :api_key => "2"},
    { :id => 3, :api_key => "3"},
    { :id => 4, :api_key => "4"},
  ]
  users.each do |info|  
    RemoteTask.user = info[:api_key]
    user = User.find(info[:id])
    p user.login
    RemoteTask.find(:all).each do |task|
      next if task.creator_id != user.id || task.content.blank?
      new_task = project.tasks.new
      attributes = {
        :message => task.content,
        :author_id => task.creator_id,
        :created_at => task.created_at
      }
      p task.content
      new_task.send :attributes=, attributes, false
      new_task.save!
      unless task.completed_at.nil?
        new_task.complete!
      end
      eval <<-END
      class RemoteComment#{new_task.id} < ActiveResource::Base
        #self.site = 'http://localhost:3000/tasks/#{task.id}'
        self.site = 'http://insane.ly/tasks/#{task.id}'
        self.user = '#{info[:api_key]}'
        self.element_name = 'comment'
      end
      END
      eval("RemoteComment#{new_task.id}").send(:find, :all).each do |comment|
        next if comment.content.blank?
        new_comment = new_task.comments.new
        attributes = {
          :message => comment.content,
          :author_id => info[:id],
          :created_at => comment.created_at,
          :updated_at => comment.updated_at
        }
        new_comment.send :attributes=, attributes, false
        new_comment.save!
      end
      attributes = { :updated_at => task.updated_at }
      new_task.send :attributes=, attributes, false
      new_task.save!
      new_task.readerships.find_or_create_by_user_id(user.id).touch
    end
  end
end