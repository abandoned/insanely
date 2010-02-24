module HashtagsHelper
  def link_to_hashtag(hashtag)
    font_size = [1.5, 0.9 + (hashtag.tasks_count.to_f / 10)].min
    css = "font-size: #{font_size}em"
    link_to_unless_current(truncate(hashtag.title, :length => 12), project_hashtag_path(@project, hashtag), :style => css) { content_tag(:span, truncate(hashtag.title, :length => 12), :class => 'highlighted', :style => css) }
  end
end