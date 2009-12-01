module LayoutHelper
  def title(page_title, show_title = true, link_title_to = current_user ? projects_path : root_path)
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
  
  def header_with_title
    haml_tag :h1 do
      haml_concat(link_to_unless_current(@show_title ? @content_for_title : 'Insanely', @link_title_to))
      if current_user
        user_options = [
          ['View account', account_path],
          ['List workmates', workmates_path]
        ]
        grouped_options = [
          ['Profile', user_options]
        ]
      
        if @project && !@project.new_record?
          project_options = [['Switch to another project', projects_path]]
          project_options << ['List assets in current project', project_assets_path(@project)]
        
          task_options = [
            ['List active tasks', project_tasks_path(@project)],
            ['List frozen tasks', project_tasks_path(@project, :status => 'iceboxed')],
            ['List completed tasks', project_tasks_path(@project, :status => 'completed')]
          ]
        
          grouped_options << ['Projects', project_options] unless project_options.empty?
          grouped_options << ['Tasks', task_options] unless task_options.empty?
        end
      
        haml_concat(select_tag('actions', grouped_options_for_select(grouped_options, nil, 'Go to...')))
      end
    end
  end
  
  def flash_message
    flash.each do |name, msg|
      haml_tag(:div, msg, :id => "flash_#{name}")
    end
  end
  
  def assignment_count
    @assignment_count ||= current_user.assignments.size
  end
  
  def project_assignment_count
    @project_assignment_count ||= @project.tasks.assigned_to(current_user).size
  end
end
