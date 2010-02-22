class ProjectsController < InheritedResources::Base
  include ProjectRights
  
  before_filter :require_user
  before_filter :creator?, :only => [:update, :destroy, :archive, :unarchive]
  before_filter :resource,  :only => [:archive, :unarchive]
  
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
  
  def archive
    if @project.archive!
      flash[:success] = "Project archived!"
    else
      flash[:failure] = "Could not archive project!"
    end
    respond_to do |format|
      format.html { redirect_to active_projects_path }
      format.xml  { render :xml => @project }
    end
  end
  
  def unarchive
    if @project.unarchive!
      flash[:success] = "Project unarchived!"
    else
      flash[:failure] = "Could not unarchive project!"
    end
    respond_to do |format|
      format.html { redirect_to active_projects_path }
      format.xml  { render :xml => @project }
    end
  end
  
  private
  
  def begin_of_association_chain
    current_user
  end
  
  def creator?
    resource.creator == current_user
  end
end
