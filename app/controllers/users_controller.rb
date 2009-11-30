class UsersController < InheritedResources::Base
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :except => [:new, :create]
  
  actions :show, :edit, :update
  
  def update
    update!{ account_path }
  end
  
  private

  def resource
    @user ||= current_user
  end
end
