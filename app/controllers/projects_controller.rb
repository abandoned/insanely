class ProjectsController < InheritedResources::Base
  include ProjectRights
  
  before_filter :require_user
  before_filter :creator?, :only => [:update, :destroy]
  
  respond_to :html, :xml
  actions :all, :except => [:show]
  inherits_states
  
  helper_method :creator?, :can_remove?
  
  def show
    @tasks = resource.tasks
  end
  
  def create
    @project = current_user.created_projects.new(params[:project])
    create! do |success, failure|
      success.html do
        redirect_to edit_resource_path
      end
    end
  end
  
  def update
    update!{ edit_resource_path }
  end
  
  private
  
  def begin_of_association_chain
    current_user
  end
  
  def creator?
    resource.creator == current_user
  end
end
