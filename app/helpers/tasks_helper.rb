module TasksHelper
  def highlight_tags(msg)
    msg.dup.scan(/\B#(\w+)/i) do |m|
      msg.gsub!(/##{m}/i, "\"##{m}\":#{project_hashtag_path(@project, @project.hashtags.find_by_title(m.to_s.downcase))}")
    end
    msg
  end
  
  def highlight_assigns(msg)
    msg.dup.scan(/(\B)@(\w+)/i) do |b, m|
      participant = @project.participants.find_by_login(m.downcase)
      unless participant.nil?
        msg.gsub!(/#{b}@#{m}/i, "#{b}\"@#{m.downcase}\":#{assigned_project_participant_tasks_path(@project, participant)}")
      end
    end
    msg
  end
  
  def insanely_format(msg)
    textilize(highlight_assigns(highlight_tags(auto_link(h(msg)) { |text| truncate(text) })))
  end
  
  def set_up_readership_css(task)
    html_options = {}
    if task.comments_count > 0
      readership = current_user.readerships.find_by_task_id(task.id)
      html_options.merge!({ :class => "unread" }) if readership.nil? || task.updated_at > readership.updated_at
    end
    html_options
  end
end
