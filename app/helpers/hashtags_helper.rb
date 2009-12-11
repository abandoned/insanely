module HashtagsHelper
  def link_to_tag(hashtag)
    classes = []
    if hashtag.tasks_count > 3
      classes << 'large'
    end
    link_to_unless_current(truncate(hashtag.title, :length => 11), project_hashtag_path(@project, hashtag), :class => classes.join(' ')) { content_tag(:span, hashtag.title, :class => (classes << 'highlighted').join(' '))}
  end
end