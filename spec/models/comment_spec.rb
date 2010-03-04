require File.dirname(__FILE__) + '/../spec_helper'

describe Comment do
  before(:each) do
    @user1 = Factory(:user)
    @user2 = Factory(:user)
    @project = Factory(
      :project,
      :creator => @user1,
      :participants => [@user1, @user2])
    @task = Factory(
      :task,
      :project => @project,
      :author => @user1)
    @comment = Factory(
      :comment,
      :task => @task,
      :author => @user1)
  end
end

# == Schema Information
#
# Table name: comments
#
#  id         :integer         not null, primary key
#  task_id    :integer
#  author_id  :integer
#  message    :text
#  created_at :datetime
#  updated_at :datetime
#

