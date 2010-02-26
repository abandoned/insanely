module ProjectsHelper
  def assignment_count(project)
    @assignment_counts ||= []
    @assignment_counts[project.id] ||= project.tasks.assigned_to(current_user).size
  end
  
  def project_links
    links = [{
      :name => 'Dashboard',
      :path => projects_path
    }]
    if current_user.projects.archived.size > 0
      links << {
        :name => 'Archived projects',
        :path => archived_projects_path
      }
    links << {
      :name => 'Workmates',
      :path => workmates_path
    }
    end
    links
  end
  
  def project_unread?(project)
    readership = current_user.readerships.find_by_readable_id_and_readable_type(project.id, 'Project')
    return true if readership.nil? || project.updated_at > readership.updated_at
    false
  end
end