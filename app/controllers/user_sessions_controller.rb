class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:success] = "Hi there, #{@user_session.login}."
      redirect_back_or_default(projects_path)
    else
      if @user_session.errors.full_messages == ["Your account is not active"]
        flash.now[:failure] = "Your account is not active."
      else
        flash.now[:failure] = "Please check your login and password."
      end
      render :action => :new
    end
  end

  def destroy
    if current_user
      current_user_session.destroy
      flash[:success] = "You are logged out."
    end
    redirect_back_or_default(root_path)
  end
end
