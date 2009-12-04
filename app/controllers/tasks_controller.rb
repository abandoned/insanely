class TasksController < InheritedResources::Base
  before_filter :require_user
  before_filter :resource, :only => [:complete, :uncomplete, :freeze, :unfreeze]
  belongs_to :project
  respond_to :html, :xml
  has_scope :query
  has_scope :status, :default => 'active', :only => :index
  
  def index
    index!
    touch_readership(@project)
  end
  
  def show
    show! {
      @comment = resource.comments.new
    } rescue redirect_to(:action => :index)
    touch_readership(@task)
  end
  
  def create
    create!{ collection_path }
    @task.update_attribute(:author, current_user)
  end
  
  def destroy
    destroy!{ collection_path(:status => params[:status], :page => params[:page]) }
  end
  
  def complete
    if @task.complete!
      flash[:notice] = "Task completed!"
    else
      flash[:error] = "Could not complete task!"
    end
    respond_to do |format|
      format.html { redirect_to(collection_path(:status => params[:status], :page => params[:page])) }
      format.xml  { render :xml => @task }
    end    
  end
  
  def uncomplete
    if @task.uncomplete!
      flash[:notice] = "Task uncompleted!"
    else
      flash[:error] = "Could not uncomplete task!"
    end
    redirect_to(collection_path(:status => params[:status], :page => params[:page]))
  end
  
  def freeze
    if @task.icebox!
      flash[:notice] = "Task frozen!"
    else
      flash[:error] = "Could not freeze task!"
    end
    redirect_to(collection_path(:status => params[:status], :page => params[:page]))
  end
  
  def unfreeze
    if @task.unfreeze!
      flash[:notice] = "Task unfrozen!"
    else
      flash[:error] = "Could not unfreeze task!"
    end
    redirect_to(collection_path(:status => params[:status], :page => params[:page]))
  end
  
  def assigned
    @project = current_user.projects.find(params[:project_id])
    @participant = @project.participants.find(params[:participant_id])
    @tasks = @project.tasks.assigned_to(@participant).paginate(:page => params[:page], :include => [:assets])
    if @tasks.size == 0
      flash[:error] = "#{@participant.login.capitalize} has no assignments in this project."
      redirect_to(:action => :index)
    end
  end
  
  private
  
  def collection
    @tasks ||= end_of_association_chain.paginate(:page => params[:page], :include => [:assets])
  end
  
  def begin_of_association_chain
    current_user
  end
  
  def touch_readership(readable)
    readership = current_user.readerships.find_or_initialize_by_readable_id_and_readable_type(readable.id, readable.class.to_s)
    readership.touch
  end
end
