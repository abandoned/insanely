class Notifier < ActionMailer::Base  
  default_url_options[:host] = 'insane.ly'
  
  def password_reset_instructions(user)  
    subject       'Reset Your Password'
    from          'rhizome@insane.ly'
    recipients    user.email  
    sent_on       Time.now  
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)  
  end
  
  def new_task(task)
    subject       "[#{task.project.title}] #{task.author.login.capitalize} added a task"
    from          'rhizome@insane.ly'
    recipients    task.project.participants.reject{ |u| u == task.author }.map{ |u| u.email }
    sent_on       Time.now
    body          :task => task
  end
  
  def new_comment(comment)
    subject       "[#{comment.task.project.title}] #{comment.author.login.capitalize} posted a comment"
    from          'rhizome@insane.ly'
    recipients    comment.task.project.participants.reject{ |u| u == comment.author }.map{ |u| u.email }
    sent_on       Time.now
    body          :comment => comment, :task_excerpt => awesome_truncate(comment.task.message, 81)
  end
  
  def status_update(task, action)
    subject       "[#{task.project.title}] #{task.author.login.capitalize} #{past(action)} a task"
    from          'rhizome@insane.ly'
    recipients    task.project.participants.reject{ |u| u == task.author }.map{ |u| u.email }
    sent_on       Time.now
    body          :task => task
  end
  
  private
  
  def awesome_truncate(text, length=30, truncate_string="...")
    return if text.nil?
    l = length - truncate_string.mb_chars.length
    text.mb_chars.length > length ? text[/\A.{#{l}}\w*\;?/m][/.*[\w\;]/m] + truncate_string : text
  end
  
  def past(verb)
    case verb[-1, 1]
    when /[aeiou]/
      verb + 'd'
    when 'y'
      verb.chop + 'ied' 
    else
      verb + 'ed'
    end
  end
end