require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  before(:each) do
    @user = Factory(:user)
  end
  
  it "should destroy dependent collaborations and reverse collaborations if destroyed" do
    Factory(:collaboration, :user => @user)
    Factory(:collaboration, :workmate => @user)
    proc { @user.destroy }.should change(Collaboration, :count).by(-2)
  end
end