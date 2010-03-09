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
    links << {
      :name => 'Files',
      :path => project_assets_path
    }
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
  
  def unread_comments?(task)
    html_options = {}
    if current_user.unreads.find_by_readable_type_and_readable_id('Comment', task.comments.collect(&:id)).present?
      html_options.merge!({ :class => 'unread' })
    end
    html_options
  end
end

