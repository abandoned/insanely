class CommentsController < InheritedResources::Base
  before_filter :require_user
  belongs_to :project, :task
  respond_to :html, :xml
  actions :all, :except => [:show, :edit, :update]
  
  def create
    @project = Project.find(params[:project_id])
    @task = @project.tasks.find(params[:task_id])
    @comment = @task.comments.build(params[:comment])
    @comment.author = current_user
    create! do |success, failure|
      success.html { redirect_to project_task_path(@project, @task) }
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
end