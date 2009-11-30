class WelcomeController < ApplicationController
  def index
    return(redirect_to(projects_path)) if current_user
  end
end
