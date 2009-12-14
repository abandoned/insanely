module ProjectsHelper
  def synopsis_of(project)
    links = [link_to("#{project.tasks.active.count} active tasks", project_tasks_path(project), readership_html(project, 'active'))]
    if project.tasks.completed.count > 0
      links << link_to("#{project.tasks.completed.count} completed tasks", project_tasks_path(project, :status => 'completed'), readership_html(project, 'completed'))
    end
    if project.tasks.iceboxed.count > 0
      links << link_to("#{project.tasks.iceboxed.count} frozen tasks", project_tasks_path(project, :status => 'iceboxed'), readership_html(project, 'iceboxed'))
    end
    if project.tasks.assigned_to(current_user).count > 0
      links << link_to(pluralize(project.tasks.assigned_to(current_user).count, 'assignment'), assigned_project_participant_tasks_path(project, current_user))
    end
    links.join(' ').html_safe!
  end
  
  def chart(project)
    data = []
    bar_colors = []
    if project.tasks.active.count
      data << [project.tasks.active.count]
      bar_colors << '333333'
    end
    if project.tasks.completed.count
      data << [project.tasks.completed.count]
      bar_colors << '999999'
    end
    if project.tasks.iceboxed.count
      data << [project.tasks.iceboxed.count]
      bar_colors << 'cccccc'
    end
    Gchart.bar(:data => data,
               :bar_colors => bar_colors,
               :stacked => false,
               :size => '90x60',
               :axis_colors => 'ffffff',
               :background => 'c4e9e2',
               # this is a bit of a hack to remove axes
               :custom => 'chxt=x,y&chxs=0,c4e9e2,1,0,t,c4e9e2|1,c4e9e2,1,0,t,c4e9e2')
  end
end
