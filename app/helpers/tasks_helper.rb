module TasksHelper
  def highlight_tags(msg, hashtags)
    msg.dup.scan(/\B#(\w+)/i) do |m|
      hashtag = hashtags.find_by_title(m.to_s.downcase)
      unless hashtag.nil?
        msg.gsub!(/##{m}/i, "\"##{m}\":#{project_hashtag_path(@project, hashtag)}")
      end
    end
    msg
  end
  
  def highlight_assigns(msg, participants)
    msg.dup.scan(/(\B)@(\w+)/i) do |b, m|
      participant = participants.find_by_login(m.downcase)
      unless participant.nil?
        msg.gsub!(/#{b}@#{m}/i, "#{b}\"@#{m.downcase}\":#{assigned_project_participant_tasks_path(@project, participant)}")
      end
    end
    msg
  end
  
  def insanely_format(obj)
    return false if @project.nil?
    
    if obj.respond_to?('hashtags') && obj.respond_to?('project')
      hashtags      = obj.hashtags
      participants  = obj.project.participants
    elsif obj.respond_to?('task')
      hashtags      = obj.task.hashtags
      participants  = obj.task.project.participants
    else
      return false
    end
    textilize(highlight_assigns(highlight_tags(auto_link(h(obj.message)) { |text| truncate(text) }, hashtags), participants))
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
      html_options.merge!({ :class => 'highlighted' }) if readership.nil? || readable.tasks.status(status).most_recent.first.updated_at > readership.updated_at
    end
    html_options
  end
end

