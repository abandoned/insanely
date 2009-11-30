class Notifier < ActionMailer::Base  
  default_url_options[:host] = "insane.ly"
  
  def password_reset_instructions(user)  
    subject       "Reset Your Password"  
    from          "rhizome@insane.ly"  
    recipients    user.email  
    sent_on       Time.now  
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)  
  end
  
  private
  
  def awesome_truncate(msg, length=30, truncate_string="...")
    return if msg.nil?
    l = length - truncate_string.mb_chars.length
    msg.mb_chars.length > length ? msg[/\A.{#{l}}\w*\;?/m][/.*[\w\;]/m] + truncate_string : msg
  end
end