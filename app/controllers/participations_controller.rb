class ParticipationsController < InheritedResources::Base
  before_filter :require_user
  
  belongs_to :project
  
  helper_method :can_remove?
  
  def new
    new! {
      @nonparticipants = @current_user.workmates.reject{ |w| @project.participants.include?(w) }
      if @nonparticipants.empty?
        flash[:error] = 'All your workmates are already participating in this project.'
        return redirect_to(:action => :index)
      end
    }
  end
  
  def create
    @project ||= @current_user.projects.find(params[:project_id])
    if params[:participation][:participant_id]
      participant = @current_user.workmates.find(params[:participation][:participant_id])
      if participant
        flash[:notice] = 'Person added to project!'
        @project.participants << participant
      else
        flash[:error] = 'Person not added to project!'
      end
    elsif params[:participation][:invitee_email]
      flash[:error] = 'This feature is not active'
    else
      flash[:error] = 'Person not added to project!'
    end
    return redirect_to collection_url(@project)
  end
  
  def destroy
    @project ||= @current_user.projects.find(params[:project_id])
    participant = resource.participant
    if can_remove?(participant) && @project.participations.find_by_participant_id(participant.id).destroy
      flash[:notice] = 'Person removed from project!'
      if i_am?(participant)
        return(redirect_to projects_url)
      end
    else
      flash[:error] = 'Person not removed from project!'
    end
    redirect_to collection_url
  end
  
  private
  
  def begin_of_association_chain
    @current_user
  end
  
  def can_remove?(participant)
    (created?(@project) && !i_am?(participant) && !project_created_by?(participant)) ||
      (!created?(@project) && i_am?(participant))
  end
  
  def i_am?(participant)
    participant.id == @current_user.id
  end
  
  def created?(project)
    @current_user.id == @project.creator_id
  end
  
  def project_created_by?(participant)
    participant.id == @project.creator_id
  end
end
