# == Schema Information
#
# Table name: tasks
#
#  id             :integer         not null, primary key
#  project_id     :integer
#  author_id      :integer
#  message        :string(255)
#  status         :string(255)
#  comments_count :integer         default(0)
#  created_at     :datetime
#  updated_at     :datetime
#

require File.dirname(__FILE__) + '/../spec_helper'

describe Task do
  before(:each) do
    @user = Factory(
      :user,
      :login => 'foo'
    )
    @project = Factory(
      :project,
      :creator => @user
    )
    @task = Factory(
      :task,
      :project => @project,
      :author => @user,
      :message => '#foo @foo'
    )
  end
  
  it 'should create hashtag' do
    @task.should have(1).hashtag
    @task.hashtags.first.title.should == 'foo'
  end
  
  it 'should create assignment' do
    @task.should have(1).assignment
    @task.assignees.first.should == @user
  end
  
  it 'should destroy hashtag' do
    @task.update_attribute(:message, '@foo')
    @task.reload.should have(1).hashtag
    @task.hashtags.first.title.should == 'untitled'
  end
  
  it 'should destroy assignment' do
    @task.update_attribute(:message, '#foo -@foo')
    @task.reload.should have(0).assignments
  end
  
  it 'should parse assignment at the beginning of line' do
    @task.update_attribute(:message, '@foo')
    @task.reload.should have(1).assignment
    @task.assignees.first.should == @user
  end
  
  it 'should not parse a word with an at sign after first letter' do
    @task.update_attribute(:message, 'foo@foo')
    @task.reload.should have(0).assignments
  end
end
