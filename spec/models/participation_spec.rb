require File.dirname(__FILE__) + '/../spec_helper'

describe Participation do
  before(:each) do
    @user1 = Factory(:user)
    @user2 = Factory(:user)
    @project = Factory(
      :project,
      :creator => @user1
    )
  end
  
  it 'should create a valid participation' do
    @project.participants << @user2
    @project.should have(2).participations
  end
  
  it 'should not add an existing participant to a project again' do
    lambda { @project.participants << @user1 }.should raise_error(ActiveRecord::RecordInvalid)
  end
  
  it 'should not validate with a nonexisting user_id' do
    lambda { @project.participations.create!(:participant_id => 999) }.should raise_error(ActiveRecord::RecordInvalid)
  end
end
