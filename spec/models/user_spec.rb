# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe User do
  before {makeuser}
   subject {@user}
   
  it {should respond_to(:admin)}
  it {should respond_to(:feed)}
  it {should be_valid}
  it {should_not be_admin}
  it { should respond_to(:password_confirmation)}
  it {should respond_to(:remember_token)}
  it {should respond_to(:authenticate)}
  it {should respond_to(:microposts)}
  it {should respond_to(:name)}
  it {should respond_to(:email)}
  it {should be_valid}
  it {should respond_to(:password_digest)}
  it {should respond_to(:password)}
  it {should respond_to(:password_confirmation)}
  it "shouldn't allow access to :admin attribute" do 
    expect do
      @user.update_attributes(admin: true)
    end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
  end #shouldnt allow access
  
  describe "micropost associations" do
    before {@user.save}
    let!(:older_mciropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:new_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end
    it "should have proper order for microposts" do
      @user.microposts.should == [new_micropost, older_mciropost]
    end
    it "deleting microposts should follow a user destruction" do
      microposts=@user.microposts.dup
      @user.destroy
      microposts.should_not be_empty
      microposts.each do |micropost|
	Micropost.find_by_id(micropost.id).should == nil
      end
    end
#     describe "play" do
#       puts @user.to_yaml
#       puts @faf.to_yaml
#       it "mydo" do
# 	puts @user.to_yaml
#       end
#     end
    describe "status" do
      let(:unfollowed_post) do
	FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end
      its(:feed) {should include(newer_micropost)}
      its(:feed) {should include(older_micropost)}
      its(:feed) {should_not include(unfollowed_post)}
    end
  end #associations    

  
  
  describe "with admin attribute set to 'true' " do
    before do
      @user.save!
      @user.toggle!(:admin)
    end
    
  end #with admin set to true
  
  describe "the remember token" do
    before {@user.save}
    its(:remember_token){should_not be_blank}
  end
  
  describe "when name is not present" do
    before {@user.name = " "}
    it { should_not be_valid}
  end
  
  describe "when password is not present" do
    before {@user.password = @user.password_confirmation= " "}
    it {should_not be_valid}
  end
  
  describe "when password and confirmation don't match" do
    before {@user.password_confirmation = "mismatch"}
    it {should_not be_valid}
  end
  
  describe "when password confirm is nil" do
    before {@user.password_confirmation = nil}
    it {should_not be_valid}
  end
  
  
  describe "when email is not present" do
    before {@user.email = " "}
    it {should_not be_valid}
  end
  
  describe "when name is too long" do
    before {@user.name = "a"*51}
    it {should_not be_valid}
  end
  
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses= %w[user@foo,com user_at_foo.com example.user@foo. foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
	@user.email=invalid_address
	@user.should_not be_valid
      end
    end
  end
    
    describe "when an email format is valid" do
      it "should be valid" do
	addresses= %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
	addresses.each do |valid_address|
	  @user.email=valid_address
	  @user.should be_valid
	end
      end
    end
    
    describe "when an email address is already taken" do
      before do
	user_with_same_email = @user.dup
	user_with_same_email.email=@user.email.upcase
	user_with_same_email.save
      end      
      it {should_not be_valid}
    end
    
    describe "with a password that's too short" do
      before { @user.password = @user.password_confirmation = "a" * 5 }
      it { should be_invalid }
    end
        

    describe "return value of authenticate method" do
      before { @user.save }
      let(:found_user) { User.find_by_email(@user.email) }

      describe "with valid password" do
	it { should == found_user.authenticate(@user.password) }
      end
      
      describe "with invalid password" do
	let(:user_for_invalid_password) { found_user.authenticate("invalid") }
	it { should_not == user_for_invalid_password }
	specify { user_for_invalid_password.should be_false }
      end
  
      describe "email should be saved as lower case" do
	let(:mixed_case_email){"Foo@ExAmple.com"}
        it "should save to all lower case" do
	  @user.email = mixed_case_email
	  @user.save
	  @user.reload.email.should == mixed_case_email.downcase
	end
      end
    end
    
  end
