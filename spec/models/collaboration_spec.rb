require File.dirname(__FILE__) + '/../spec_helper'

describe Collaboration do
  before(:each) do
    @user1 = Factory(:user)
    @user2 = Factory(:user)
    @collaboration = Factory(:collaboration,
      :user => @user1,
      :workmate => @user2)
  end
end