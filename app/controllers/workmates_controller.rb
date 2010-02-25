class WorkmatesController < InheritedResources::Base
  before_filter :require_user
  actions :index, :new, :create, :destroy
  
  def new
    @workmate = current_user.workmates.new
  end
  
  def create
     user = User.find_by_email(params[:workmate][:email])
     unless user.nil?
       unless current_user.workmates.include?(user)
         current_user.workmates << user
         flash[:success] = 'Added workmate!'
       else
         flash[:failure] = 'User is already your workmate!'
       end
       redirect_to workmates_path
     else
       flash.now[:failure] = 'Cannnot invite someone not on the system for now!'
       @workmate = current_user.workmates.build(params[:workmate])
       render :action => 'new'
     end
   end
  
  private
  
  def collection
    @workmates ||= current_user.workmates
  end
  
  def resource
    @workmate ||= current_user.workmates.find(params[:id])
  end
end