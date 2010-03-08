class CommentsController < InheritedResources::Base
  before_filter :require_user
  after_filter :create_unread_comment, :only => [:create] 
  
  belongs_to :project, :task
  respond_to :html, :xml
  actions :all, :except => [:show, :edit, :update]
  
  def create
    @project = Project.find(params[:project_id])
    @task = @project.tasks.find(params[:task_id])
    @comment = @task.comments.build(params[:comment])
    @comment.author = current_user
    create! do |success, failure|
      success.html do
        touch_unread(@task)
        touch_unread(@project)
        if params[:notify]
          Notifier.send_later(:deliver_new_comment, @comment)
        end
        redirect_to project_task_path(@project, @task)
      end
      failure.html do
        return(render :template => 'tasks/show')
      end
    end
  end
  
  def update
    update! { project_task_path(@project, @task) }
  end
  
  def destroy
    destroy!{ project_task_path(@project, @task) }
  end
  
  private
  
  def begin_of_association_chain
    current_user
  end
  
  def create_unread_comment
    (@project.participants - [current_user]).each do |user|
      @comment.unreads.create!({
        :project_id   => @project.id,
        :user_id      => user.id,
      })
    end
  end
end