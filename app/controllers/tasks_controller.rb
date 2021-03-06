class TasksController < InheritedResources::Base
  before_filter :require_user
  before_filter :resource,  :only => [:complete, :uncomplete, :icebox, :defrost]
  after_filter :notify,     :only => [:complete, :uncomplete, :icebox, :defrost]
  
  after_filter :create_unread_task,     :only => [:create, :update] 
  after_filter :read_unread,            :only => [:show]
  after_filter :read_all_unread_tasks,  :only => [:active]
  after_filter :all_read_unread,        :only => [:complete, :archive]
  
  belongs_to :project
  respond_to :html
  has_scope :query, :only => [:index]
  inherits_states
  
  def index
    index!
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
  
  private
  
  def collection
    @tasks ||= end_of_association_chain.all(:include => [:assets])
  end
  
  def begin_of_association_chain
    current_user
  end
  
  def create_unread_task
    (@project.participants - [current_user]).each do |user|
      @task.unreads.create!({
        :project_id   => @project.id,
        :user_id      => user.id,
      })
    end
  end
  
  # 
  def read_unread
    Unread.destroy_all(
      :user_id      => current_user.id,
      :readable_id   => @task.id,
      :readable_type => 'Task'
    )
    @task.comments.all(:include => :unreads, :conditions => ['unreads.user_id = ?', current_user.id]).each do |comment|
      comment.unreads.each { |unread| unread.destroy }
    end
  end
  
  def read_all_unread_tasks
    Unread.destroy_all(
      :user_id      => current_user.id,
      :readable_type => 'Task'
    )
  end
  
  def all_read_unread
    @task.unreads.destroy_all
    @task.comments.all(:include => :unreads).each do |comment|
      comment.unreads.each { |unread| unread.destroy }
    end
  end
  
  def notify
    Notifier.send_later(:deliver_status_update, current_user, action_name, @task)
  end
end
