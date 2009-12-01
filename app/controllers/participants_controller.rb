class ParticipantsController < InheritedResources::Base
  before_filter :require_user
  belongs_to :project
  
  def new
    @participation = parent.participations.new
    @nonparticipants = current_user.workmates.reject{ |w| @project.participants.include?(w) }
    if @nonparticipants.blank?
      flash[:error] = 'All your workmates are already participating in this project.'
      return redirect_to(:action => :index)
    end
  end
  
  def create
    flash[:notice] = 'Not working yet.'
    redirect_to collection_url(parent)
  end
  
  private
  
  def parent
    @project ||= current_user.projects.find(params[:project_id])
  end
  
  def collection
    @participants ||= parent.participants
  end
  
  def resource
    @participation ||= parent.participation.find_by_participant_id(params[:id])
  end
end
