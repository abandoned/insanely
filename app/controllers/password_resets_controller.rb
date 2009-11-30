class PasswordResetsController < ApplicationController
  before_filter :require_no_user 
  before_filter :load_user_using_perishable_token, :only => [ :edit, :update ]
  
  def create  
    @user = User.find_by_email(params[:email])  
    if @user  
      @user.deliver_password_reset_instructions!  
      flash[:notice] = 'Link sent. Check your email in a moment or two.'
      redirect_to(root_path)
    else
      flash[:error] = 'Account not found!'
      render(:action => :new)
    end  
  end  
  
  def update  
    @user.password = params[:user][:password]  
    @user.password_confirmation = params[:user][:password_confirmation]  
    if @user.save  
      flash[:notice] = 'Password updated!'
      redirect_to(projects_path)
    else  
      render(:action => :edit)
    end  
  end  

private  
  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])  
    unless @user  
      flash[:error] = 'Account not found!'
      redirect_to(root_path)
    end
  end
end