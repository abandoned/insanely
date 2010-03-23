class WorkmatesController < ApplicationController
  before_filter :require_user
  
  def index
    @collaborations = current_user.collaborations
  end
  
  def new
    @workmate = User.new
  end
  
  def create
    workmate = User.find_by_login(params[:workmate][:login])

    unless workmate.nil?
      requested_collab = Collaboration.new(:user => current_user, :workmate => workmate)
      pending_collab = Collaboration.new(:workmate => current_user, :user => workmate, :status => 'pending')
      if requested_collab.save && pending_collab.save
        flash[:success] = 'Added workmate!'
        return redirect_to(workmates_path)
      else
        flash[:failure] = 'Cannot add workmate!'
      end
    else
      flash.now[:failure] = 'Cannnot add someone not on the system for now!'
    end
    @workmate = current_user.workmates.build(params[:workmate])
    render :action => :new
  end
 
  def update
    pending_collab = current_user.collaborations.find_by_workmate_id(params[:id])
    requested_collab = User.find(params[:id]).collaborations.find_by_workmate_id(current_user.id)
    if pending_collab && requested_collab && pending_collab.activate! && requested_collab.activate!
      flash[:success] = 'Collaboration activated!'
    end
    redirect_to workmates_path
  end

  def destroy
    pending_collab = current_user.collaborations.find_by_workmate_id(params[:id])
    requested_collab = User.find(params[:id]).collaborations.find_by_workmate_id(current_user.id)
    if pending_collab && requested_collab && pending_collab.destroy && requested_collab.destroy
      flash[:success] = 'Collaboration removed!'
    end
    redirect_to workmates_path
  end
end