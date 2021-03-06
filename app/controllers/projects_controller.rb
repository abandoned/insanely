class ProjectsController < InheritedResources::Base
  include ProjectRights
  
  before_filter :require_user, :except => [:show]
  before_filter :require_user, :only => [:show], :if => false
  before_filter :creator?, :only => [:destroy]
  before_filter :resource, :only => [:archive, :unarchive]
  
  respond_to :html
  actions :all, :except => [:show]
  inherits_states
  
  helper_method :creator?, :can_remove?
  
  def index
    @projects = current_user.projects.active.all(:order => 'updated_at desc')
  end
  
  def create
    @project = current_user.created_projects.new(params[:project])
    create!{ active_project_tasks_path(@project) }
  end
  
  def update
    update!{ edit_resource_path }
  end
  
  def archive
    if @project.archive!
      flash[:success] = 'Project archived!'
    else
      flash[:failure] = 'Could not archive project!'
    end
    respond_to do |format|
      format.html { redirect_to active_projects_path }
    end
  end
  
  def unarchive
    if @project.unarchive!
      flash[:success] = 'Project unarchived!'
    else
      flash[:failure] = 'Could not unarchive project!'
    end
    respond_to do |format|
      format.html { redirect_to active_projects_path }
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
