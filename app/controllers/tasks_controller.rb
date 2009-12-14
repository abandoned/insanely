class TasksController < InheritedResources::Base
  before_filter :require_user
  before_filter :resource, :only => [:complete, :uncomplete, :icebox, :defrost]
  after_filter :touch_task, :only => [:show, :complete, :uncomplete, :icebox, :defrost]
  
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
  end
  
  def create
    create! do |success, failure|
      success.html do
        @task.update_attribute(:author, current_user)
        if params[:notify]
          Notifier.send_later(:deliver_new_task, @task)
        end
        redirect_to collection_path
      end
    end
  end
  
  def update
    update!{ collection_path }
  end
  
  def destroy
    destroy!{ collection_path(:status => params[:status], :page => params[:page]) }
  end
  
  def complete
    if @task.complete!
      flash[:success] = "Task completed!"
    else
      flash[:failure] = "Could not complete task!"
    end
    respond_to do |format|
      format.html { redirect_to(collection_path(:status => params[:status], :page => params[:page])) }
      format.xml  { render :xml => @task }
    end    
  end
  
  def uncomplete
    if @task.uncomplete!
      flash[:success] = "Task uncompleted!"
    else
      flash[:failure] = "Could not uncomplete task!"
    end
    redirect_to(collection_path(:status => params[:status], :page => params[:page]))
  end
  
  def icebox
    if @task.icebox!
      flash[:success] = "Task iceboxed!"
    else
      flash[:failure] = "Could not icebox task!"
    end
    redirect_to(collection_path(:status => params[:status], :page => params[:page]))
  end
  
  def defrost
    if @task.defrost!
      flash[:success] = "Task defrosted!"
    else
      flash[:failure] = "Could not defrost task!"
    end
    redirect_to(collection_path(:status => params[:status], :page => params[:page]))
  end
  
  def assigned
    @project = current_user.projects.find(params[:project_id])
    @participant = @project.participants.find(params[:participant_id])
    @tasks = @project.tasks.assigned_to(@participant).paginate(:page => params[:page], :include => [:assets])
    if @tasks.size == 0
      flash[:failure] = "#{@participant.login.capitalize} has no assignments in this project."
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
  
  def touch_task
    touch_readership(@task)
  end
end
