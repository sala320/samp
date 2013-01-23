require 'spec_helper'

describe "MicropostPages" do
  subject {page}
  let(:user) {FactoryGirl.create(:user)}
  before {visit signin_url}
  before {signin user}
  
  describe "micropost creation" do
    before {visit root_path}
  end #micro creation
  
  describe "micropost destruction" do
    before {FactoryGirl.create(:micropost, user: user)}
    
    describe "as correct user" do 
      before {visit root_path}
	it "should delete a micropost" do
	  expect { click_link "delete" }.to change(Micropost, :count).by(-1)
	end
    end
  end
  
  describe "with invalid info" do 
    it "should not create a mp" do
      expect {click_button "Post"}.not_to change(Micropost, :count)
      expect {click_button "Post"}.not_to change(Microposts.all.length)
    end
    
    describe "error messages" do 
      before {click_button "Post"}
      it {should have_content('error')}
    end #error msgs
  end #with invalid
  
  describe "with valid info" do 
    before {fill_in 'micropost_content', with: "lorem ips"}
    it "should make a mp" do
      expect {click_button "Post"}.to change(Micropost, :count)
      expect {click_button "Post"}.to change(Micropost.all.length)
      
    end #should make a mp
  end #valid info

end
