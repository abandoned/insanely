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
  
  def flash_message
    flash.delete(:notice)
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
