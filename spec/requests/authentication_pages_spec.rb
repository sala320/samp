require 'spec_helper'

describe "AuthenticationPages" do
  subject {page}
  let(:submit) {'Sign in'}
  
  describe "signin page" do
    before {visit signin_path}    
    it { should have_selector('h1', text: 'Sign in')}
    it {should have_selector('title', mytitle: 'Sign in')}
    
    describe "with valid information" do
      let (:user) {FactoryGirl.create(:user)}
      
      before do
	valid_signin(user)
      end
      #before {fill_in "Email", with: user.email}
      #before {fill_in "Password", with: user.password}
      
      it {should_not have_selector('h1', text: 'Sign in')}
      it {should have_link('Users', link: users_path)}
      it {should have_selector('title', mytitle: user.name)}      
      it {should have_selector('title', blah: user.name)}
      it {should have_link('Settings', href:edit_user_path(user))}
      it {should have_link('Profile', flink: user_path(user))}
      it {should have_link('Sign out', flink: signout_path)}
      it {should_not have_link('Sign in', href: signin_path)}
      describe "followed by signout" do
	before {click_link "Sign out"}
	it {should have_link('Sign in')}
      end
    end
    
    describe "with invalid info" do 
      
      before {click_button :submit}
      
      it {should have_selector('title', text: 'Sign in')}
      it {should have_selector('div.alert.alert-error', text: 'Invalid')}
      it {should_not have_link('Settings')}
      it {should_not have_link('Profile')}
      it {should_not have_link('Sign out')}
      
      describe "after going to home page" do
	before {click_link "Home"}
	it {should_not have_selector('div.alert.alert-error', text: 'Invalid')}
      end
    end
  
  describe "when invalid information submitted" do
    before {click_button submit}
    
    it {should have_selector('div.alert.alert-error', text: 'Invalid')}
  end
 end
 
 describe "authorization" do
   
   describe "for non admin in users" do 
     let(:user) {FactoryGirl.create(:user)}
     let(:user2) {FactoryGirl.create(:user1)}
     before do
       visit signin_path
       signin(user)
     end
     
     describe "submitting a DELETE request to the Users#destroy action" do
       before {delete user_path(user2)}
       specify {response.should redirect_to(root_path)}
     end #submit delete
   end #non admin users
   
   describe "for non-signed-in users" do
     let(:user){FactoryGirl.create(:user)}
     
     describe "when attempting to visit a protected page" do
       before do
	 visit edit_user_path(user)
       end
       
       after do
	 click_link "Sign out"
       end
       
            describe "after signing in" do
	      before {valid_signin user}
	      it {should have_selector('title', text: 'Edit user')}
	      
	    end #after signin in
     end #protected pages
     
     
     
     
     describe "in the user controller" do
       
       describe "visiting the edit page" do
	 before {visit edit_user_path(user)}
	 it {should have_selector('title', text: 'Sign in')}
       end
       
       describe "submitting the update action" do
	 before {visit edit_user_path(user)}
 	 it {should have_selector('title', text: 'Sign in')}
#  	 specify {response.should redirect_to(signin_path)}
	 describe "forwarding should occur once" do
	  before do
	    fill_in "Email", with: "wjandecali24"
	    click_button "Sign in"
	  end
	  describe "final step" do
	    before do
	      valid_signin user
	      delete '/signout'
	      visit '/signin'
	      valid_signin user
	    end
	   it {should have_selector('title', text: user.name)}
	  end
	 end #forwarding once
       end #submitting action
       
       describe "visiting the Users index page" do
	 before {visit users_path}
	 it {should have_selector('title', text: 'Sign in')}
       end #visiting users index
     end #"in controller
   end #for users
   
   describe "for users who are signed in" do
     let(:user) {FactoryGirl.create(:user, email: "bullshit@gmail.com")}
     let(:wrong_user){FactoryGirl.create(:user, email: "wjandali2@gmail.com")}
     before {visit signin_path}
     before {signin user}
     
     
     describe "visiting Users#edit page" do
       before {visit edit_user_path(wrong_user)}
       it {should_not have_selector('title', text: full_title('Edit user'))}
     end #visiting wrong edit pages
     
     describe "submitting a PUT request to the Users#update action" do
       before {put user_path(wrong_user)}
       specify {response.should redirect_to(root_path)}
     end #submitting update action
                                         
   end #for users signed in
   
 end #authorization
 
   
  

  
end #Authentication
