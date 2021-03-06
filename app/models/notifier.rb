class Notifier < ActionMailer::Base  
  default_url_options[:host] = 'insane.ly'
  
  def password_reset_instructions(user)  
    subject     '[insanely] Reset your password!'
    from        'rhizome@insane.ly'
    recipients  user.email  
    sent_on     Time.now  
    body        :edit_password_reset_url => edit_password_reset_url(user.perishable_token)  
  end
  
  def activation_instructions(user)
    subject     '[insanely] Activate your account!'
    from        'rhizome@insane.ly'
    recipients  user.email
    body        :account_activation_url => register_url(user.perishable_token)
  end
  
  def new_task(task)
    subject     "[#{task.project.title}] #{task.author.login.capitalize} posted a task!"
    from        'rhizome@insane.ly'
    recipients  task.project.participants.reject{ |u| u == task.author }.map{ |u| u.email }
    sent_on     Time.now
    body        :task => task
  end
  
  def new_comment(comment)
    subject     "[#{comment.task.project.title}] #{comment.author.login.capitalize} posted a comment!"
    from        'rhizome@insane.ly'
    recipients  comment.task.project.participants.reject{ |u| u == comment.author }.map{ |u| u.email }
    sent_on     Time.now
    body        :comment => comment, :task_excerpt => awesome_truncate(comment.task.message, 81)
  end
  
  def status_update(user, action, task)
    subject     "[#{task.project.title}] #{task.author.login.capitalize} #{past(action)} a task!"
    from        'rhizome@insane.ly'
    recipients  task.project.participants.reject{ |u| u == user }.map{ |u| u.email }
    sent_on     Time.now
    body        :task => task
  end
  
  def new_project(user, project)
    subject     "[#{project.title}] Welcome aboard!"
    from        'rhizome@insane.ly'
    recipients  user.email
    sent_on     Time.now
    body        :project => project
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