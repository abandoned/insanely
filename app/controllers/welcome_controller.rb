class WelcomeController < ApplicationController
  def index
    return(redirect_to(active_projects_path)) if current_user
    if internet_explorer?
      flash.now[:failure] = 'I look ugly in Internet Explorer. Please consider switching to another browser.'
    end
  end
  
  private 
  
  def internet_explorer?
    request.env["HTTP_USER_AGENT"] =~ /MSIE/
  end
end
