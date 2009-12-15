# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def pluralize_verb(count, verb)
    count == 1 ? "#{verb}s" : verb
  end
  
  def header_with_title
    haml_tag :h1 do
      haml_concat(link_to_unless_current(@show_title ? @content_for_title : 'Insanely', @link_title_to))
      if current_user
        grouped_options = []
        
        unless controller_name == 'projects' && action_name == 'index'
          insanely_options = [['Dashboard', projects_path]]
          grouped_options << ['Site', insanely_options]
        end
        
        projects_options = current_user.projects.reject{ |p| p == @project if @project }.collect{ |p| [p.title, project_tasks_path(p)]}
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
end
