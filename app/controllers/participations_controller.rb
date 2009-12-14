class ParticipationsController < ApplicationController
  include ProjectRights
  
  before_filter :require_user
  before_filter :find_project
  
  helper_method :can_remove?
  
  def index
    @participations = @project.participations
  end
  
  def new
    @participants = @current_user.workmates.reject{ |w| @project.participants.include?(w) }
    if @participants.empty?
      flash[:error] = 'All your workmates are already participating in this project.'
      return redirect_to(:action => :index)
    end
    @participation = Participation.new
  end
  
  def create
    # Existing workmate
    if params[:participation][:participant_id]
      participant = @current_user.workmates.find(params[:participation][:participant_id])
      if participant
        flash[:notice] = 'Person added to project!'
        @project.participants << participant
      else
        flash[:error] = 'Person not added to project!'
      end
    
    # New invitation
    elsif params[:participation][:invitee_email]
      flash[:error] = 'This feature is not active'
    else
      flash[:error] = 'Person not added to project!'
    end
    
    return(redirect_to edit_project_path(@project))
  end
  
  def destroy
    participation = @project.participations.find(params[:id])
    participant = participation.participant
    if can_remove?(participant) && participation.destroy
      flash[:notice] = 'Person removed from project!'
      if i_am?(participant)
        return(redirect_to projects_path)
      end
    else
      flash[:error] = 'Person not removed from project!'
    end
    redirect_to edit_project_path(@project)
  end
  
  private
  
  def find_project
    @project = @current_user.projects.find(params[:project_id])
  end
end
