class ParticipantsController < InheritedResources::Base
  before_filter :require_user
  belongs_to :project
  
  private
  
  def parent
    @project ||= current_user.projects.find(params[:project_id])
  end
  
  def collection
    @participants ||= parent.participants
  end
end
