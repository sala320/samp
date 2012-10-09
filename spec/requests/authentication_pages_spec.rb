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
	fill_in "Email", with: user.email
	fill_in "Password", with: user.password
	click_button :submit
      end
      #before {fill_in "Email", with: user.email}
      #before {fill_in "Password", with: user.password}
      
      it {should_not have_selector('h1', text: 'Sign in')}
      it {should have_selector('title', mytitle: 'Sign in')}      
      it {should have_selector('title', blah: user.name)}
      it {should have_link('Profile', flink: user_path(user))}
      it {should have_link('Sign out', flink: signout_path)}
      it {should_not have_link('Sign in', href: signin_path)}
      describe "followed by signout" do
	before {click_link "Sign out"}
	it {should have_link('Sign in')}
    end
    
    describe "with invalid info" do 
      before {click_button :submit}
      
      it {should have_selector('title', text: 'Sign in')}
      it {should have_selector('div.alert.alert-error', text: 'Invalid')}
      
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
  

  
end
