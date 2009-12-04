module ProjectsHelper
  def synopsis_of(project)
    links = [link_to("#{project.tasks.active.count} active tasks", project_tasks_path(project), readership_html(project, 'active'))]
    if project.tasks.completed.count > 0
      links << link_to("#{project.tasks.completed.count} completed tasks", project_tasks_path(project, :status => 'completed'), readership_html(project, 'completed'))
    end
    if project.tasks.iceboxed.count > 0
      links << link_to("#{project.tasks.iceboxed.count} frozen tasks", project_tasks_path(project, :status => 'iceboxed'), readership_html(project, 'iceboxed'))
    end
    links << link_to(pluralize(project.participants.count, 'participants'), project_participations_path(project))
    if project.tasks.assigned_to(current_user).count > 0
      links << link_to(pluralize(project.tasks.assigned_to(current_user).count, 'assignment'), assigned_project_participant_tasks_path(project, current_user))
    end
    links.join(' ')
  end
  
  def chart(project)
    lc = GoogleChart::LineChart.new("400x200", "My Results", false)
    lc.data "Line green", [3,5,1,9,0,2], '00ff00'
    lc.data "Line red", [2,4,0,6,9,3], 'ff0000'
    lc.axis :y, :range => [0,10], :font_size => 10, :alignment => :center
    lc.show_legend = false
    lc.shape_marker :circle, :color => '0000ff', :data_set_index => 0, :data_point_index => -1, :pixel_size => 10
    lc.to_url
  end
end
