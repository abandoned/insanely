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
      haml_tag(:section, :class => 'flash_wrapper') do
        haml_concat(content_tag(:div, msg, :id => "flash_#{name}"))
      end
    end
  end
  
  def in_project
    @project && @project.title.present?
  end
  
  def project_title
    haml_tag :h1, :id => 'brand' do
      if in_project
        haml_tag(:span, link_to_unless_current(@project.title, project_tasks_path(@project)))
      else
        haml_tag(:span, 'Insanely.')
      end
    end
  end
  
  def header_with_title
    haml_tag :h1 do
      haml_concat(content_tag(:span, link_to_unless_current(@show_title ? @content_for_title : 'Insanely.', @link_title_to)))
      if current_user
        grouped_options = []
        
        unless controller_name == 'projects' && action_name == 'index'
          insanely_options = [
            ['Dashboard', active_projects_path],
            ['Archived projects', archived_projects_path]
          ]
          grouped_options << ['Site', insanely_options]
        end
        
        projects_options = current_user.projects.active.reject{ |p| p == @project if @project }.collect{ |p| [p.title, active_project_tasks_path(p)]}
        grouped_options << ['Projects', projects_options]
        
        if @project && !@project.new_record?
          project_options = [
            ['Active tasks', active_project_tasks_path(@project)],
            ['Iceboxed tasks', iceboxed_project_tasks_path(@project)],
            ['Completed tasks', completed_project_tasks_path(@project)],
            ['Assets', project_assets_path(@project)]
          ]
          grouped_options << [@project.title, project_options]
        end
        
        user_options = [
          ['Account', account_path],
          ['Workmates', workmates_path]
        ]
        grouped_options << ['User', user_options]
        
        haml_concat(select_tag('actions', grouped_options_for_select(grouped_options, nil, 'Go to...')))
      end
    end
  end
  
  def footer
    #haml_concat(link_to("&copy;#{Time.now.year} Paper Cavalier", 'https://papercavalier.com'))
  end
    
  def navigation
    if current_user
      if @project && !@project.new_record?
        haml_concat(link_to project_assignment_count, assigned_project_participant_tasks_path(@project, current_user), :id => 'assignment-count')
        haml_concat(link_to_unless_current('Add task', new_project_task_path(@project)) {})
      end
      haml_concat(link_to('Log out', logout_path))
    else
      haml_concat(link_to_unless_current('Log in', new_user_session_path) { '&nbsp;'.html_safe! })
    end
  end
  
  def assignment_count
    @assignment_count ||= current_user.assignments.size
  end
  
  def project_assignment_count
    @project_assignment_count ||= @project.tasks.assigned_to(current_user).size
  end
end
