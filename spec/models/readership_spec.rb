# == Schema Information
#
# Table name: readerships
#
#  id         :integer         not null, primary key
#  task_id    :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Readership do
  before(:each) do
    @valid_attributes = {
      :task_id => 1,
      :user_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Readership.create!(@valid_attributes)
  end
end
