module TasksHelper
  def task_links
    links = [
      {
        :name => 'Dashboard',
        :path => projects_path
      }
    ]
    %w{active iceboxed completed}.each do |name|     
      if @project.tasks.send(name.to_sym).size > 0
        links << {
          :name => "#{name.capitalize} tasks",
          :path => self.send("#{name}_project_tasks_path", @project)
        }
      end
    end
    links
  end
  
  def highlight_tags(msg, hashtags)
    msg.dup.scan(/(?:^|[>\s])#(\w+)/i) do |m|
      hashtag = hashtags.find_by_title(m.to_s.downcase)
      unless hashtag.nil?
        msg.gsub!(/##{m}/i, "\"##{m}\":#{project_hashtag_path(@project, hashtag)}")
      end
    end
    msg
  end
  
  def highlight_assigns(msg, participants)
    msg.dup.scan(/(^|[>\s])@(\w+)/i) do |b, m|
      participant = participants.find_by_login(m.downcase)
      unless participant.nil?
        msg.gsub!(/#{b}@#{m}/i, "#{b}\"@#{m.downcase}\":#{assigned_project_participant_tasks_path(@project, participant)}")
      end
    end
    msg
  end
  
  def format_insanely(obj)
    return false if @project.nil?
    
    if obj.respond_to?('hashtags') && obj.respond_to?('project')
      hashtags, participants = obj.hashtags, obj.project.participants
    elsif obj.respond_to?('task')
      hashtags, participants = obj.task.hashtags, obj.task.project.participants
    else
      return false
    end
    sanitize(auto_link(textilize(highlight_assigns(highlight_tags(obj.message, hashtags), participants))) { |text| truncate(text, :length => 24) }).html_safe!
  end
  
  def readership_html(readable,status=nil)
    html_options = {}
    class_name = readable.class.to_s
    readership = current_user.readerships.find_by_readable_id_and_readable_type(readable.id, class_name)
    if class_name == 'Task'
      return html_options if readable.comments_count == 0
      html_options.merge!({ :class => 'highlighted' }) if readership.nil? || readable.updated_at > readership.updated_at
    elsif class_name == 'Project'
      return html_options if readable.tasks.count == 0
      html_options.merge!({ :class => 'highlighted' }) if readership.nil? || readable.tasks.send(status.to_sym).most_recent.first.updated_at > readership.updated_at
    end
    html_options
  end
end

