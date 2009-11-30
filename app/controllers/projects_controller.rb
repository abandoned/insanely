class ProjectsController < InheritedResources::Base
  before_filter :require_user
  before_filter :must_be_creator, :only => [:edit, :update, :destroy]
  respond_to :html, :xml
  actions :all, :except => [:show]
  
  def show
    @tasks = resource.tasks
  end
  
  def create
    @project = current_user.created_projects.new(params[:project])
    create!{ project_tasks_path(@project) }
  end
  
  def update
    update!{ project_tasks_path(@project) }
  end
  
  private
  
  def begin_of_association_chain
    current_user
  end
  
  def must_be_creator
    resource.creator == current_user
  end
end
