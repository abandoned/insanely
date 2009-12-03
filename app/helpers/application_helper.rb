# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def pluralize_verb(count, verb)
    count == 1 ? "#{verb}s" : verb
  end
  
  def header_with_title
    haml_tag :h1 do
      haml_concat(link_to_unless_current(@show_title ? @content_for_title : 'Insanely', @link_title_to))
      if current_user
        user_options = [
          ['Account', account_path],
          ['Workmates', workmates_path]
        ]
        projects_options = Project.all.reject{ |p| p == @project if @project }.collect{ |p| [p.title, project_tasks_path(p)]}
        grouped_options = [['Projects', projects_options]]
        if @project && !@project.new_record?
          project_options = [
            ['Active tasks', project_tasks_path(@project)],
            ['Frozen tasks', project_tasks_path(@project, :status => 'iceboxed')],
            ['Completed tasks', project_tasks_path(@project, :status => 'completed')],
            ['Assets', project_assets_path(@project)]
          ]
          grouped_options << [@project.title, project_options]
        end
        grouped_options << ['User', user_options]
        haml_concat(select_tag('actions', grouped_options_for_select(grouped_options, nil, 'Go to...')))
      end
    end
  end
end
