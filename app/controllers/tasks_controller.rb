class TasksController < InheritedResources::Base
  before_filter :require_user
  before_filter :resource,  :only => [:complete, :uncomplete, :icebox, :defrost]
  after_filter :touch_task, :only => [:show, :complete, :uncomplete, :icebox, :defrost]
  after_filter :notify,     :only => [:complete, :uncomplete, :icebox, :defrost]
  
  belongs_to :project
  respond_to :html, :xml
  has_scope :query, :only => [:index]
  
  def index
    index!
    touch_readership(@project)
  end
  
  def show
    show! {
      @comment = resource.comments.new
    } rescue redirect_to(active_project_tasks_path(@project))
  end
  
  def create
    create! do |success, failure|
      success.html do
        @task.update_attribute(:author, current_user)
        if params[:notify]
          Notifier.send_later(:deliver_new_task, @task)
        end
        redirect_to(active_project_tasks_path(@project))
      end
    end
  end
  
  def update
    update!{ active_project_tasks_path(@project) }
  end
  
  def destroy
    destroy! { !request.referer.nil? && request.referer !~ /tasks\/[0-9]+$/ ? request.referer : active_project_tasks_path(@project) }
  end
  
  def complete
    if @task.complete!
      flash[:success] = "Task completed!"
    else
      flash[:failure] = "Could not complete task!"
    end
    respond_to do |format|
      format.html { go_back }
      format.xml  { render :xml => @task }
    end    
  end
  
  def uncomplete
    if @task.uncomplete!
      flash[:success] = "Task uncompleted!"
    else
      flash[:failure] = "Could not uncomplete task!"
    end
    go_back
  end
  
  def icebox
    if @task.icebox!
      flash[:success] = "Task iceboxed!"
    else
      flash[:failure] = "Could not icebox task!"
    end
    go_back
  end
  
  def defrost
    if @task.defrost!
      flash[:success] = "Task defrosted!"
    else
      flash[:failure] = "Could not defrost task!"
    end
    go_back
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
  
  resource_class.aasm_states.each do |state|
    unless method_defined?(state.name)
      has_scope(state.name, :only => [state.name])
      define_method(state.name) do
        params[state.name] = 1
        collection
        render :action => :index
      end
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
  
  def notify
    Notifier.send_later(:deliver_status_update, current_user, action_name, @task)
  end
end
