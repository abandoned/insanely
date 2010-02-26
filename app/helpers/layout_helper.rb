module LayoutHelper
  def title(page_title, show_title = true, link_title_to = current_user ? active_projects_path : root_path)
    @content_for_title = page_title.to_s
    @show_title = show_title
    @link_title_to = link_title_to
  end
  
  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end
  
  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end
  
  def flash_message
    flash.each do |name, msg|
      haml_tag(:div, :class => 'flash_wrapper') do
        haml_concat(content_tag(:div, msg, :id => "flash_#{name}"))
      end
    end
  end
  
  def in_project
    @project && !@project.new_record?
  end
  
  def project_title
    haml_tag :h1, :id => 'brand' do
      if in_project
        haml_tag(:span) do
          haml_concat(link_to_unless_current(@project.title, active_project_tasks_path(@project)))
          if assignment_count(@project) > 0
            haml_concat(link_to(assignment_count(@project), assigned_project_participant_tasks_path(@project, current_user), :id => 'assignment-count'))
          end
        end
      else
        current_path = current_user ? projects_path : root_path
        haml_tag(:span, link_to_unless_current('Insanely', current_path))
      end
    end
  end
  
  def navigation
    if current_user
      if @project && !@project.new_record?
        haml_concat(link_to assignment_count(@project), assigned_project_participant_tasks_path(@project, current_user), :id => 'assignment-count')
        haml_concat(link_to_unless_current('Add task', new_project_task_path(@project)) {})
      end
      haml_concat(link_to('Log out', logout_path))
    else
      haml_concat(link_to_unless_current('Log in', new_user_session_path) { '&nbsp;'.html_safe! })
    end
  end
end
