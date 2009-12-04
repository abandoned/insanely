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
end
