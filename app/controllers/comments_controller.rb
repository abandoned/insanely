class CommentsController < InheritedResources::Base
  before_filter :require_user
  belongs_to :project, :task
  respond_to :html, :xml
  actions :all, :except => [:show, :edit, :update]
  
  def create
    create! do |success, failure|
      @comment.update_attribute(:author, current_user)
      success.html { redirect_to project_task_path(@project, @task) }
      failure.html { return render :template => 'tasks/show' }
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