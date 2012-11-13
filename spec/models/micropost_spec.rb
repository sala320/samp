require 'spec_helper'

describe Micropost do
  let(:user) {FactoryGirl.create(:user)}
  before do
    @micropost=user.microposts.build(content: "Lorem ipsum")
  end
  subject {@micropost}
  it {should respond_to(:content)}
  it {should respond_to(:user_id)}
  specify {@micropost.should respond_to(:content)}
  
  it {should be_valid}
  it {should respond_to(:user)}
  its(:user){ should == user}
  
  describe "when missing user_id" do 
    before {@micropost.user_id = nil}
    it {should_not be_valid}
  end
  
  describe "when too long" do
    before {@micropost.content = "a"*141}
    it {should_not be_valid}
  end
  
  describe "when content blank" do 
    before {@micropost.content = " "}
    it {should_not be_valid}
  end
  
  describe "when i mess around" do
    it {should be_valid}
  end
  
  describe "accessible properties" do
    it "should not allow access to user_id" do
      expect do
	Micropost.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end
  
  
end
