module ProjectsHelper
  def assignment_count(project)
    @assignment_counts ||= []
    @assignment_counts[project.id] ||= project.tasks.assigned_to(current_user).size
  end
  
  def project_links
    links = [
      {
        :name => 'Dashboard',
        :path => projects_path
      }
    ]
    if current_user.projects.archived.size > 0
      links << {
        :name => 'Archived projects',
        :path => archived_projects_path
      }
    end
    links
  end
end