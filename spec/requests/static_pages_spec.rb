require 'spec_helper'



describe "Static pages" do
  subject {page}
  
  shared_examples_for "all static pages" do
    it {should have_selector('h1', text:h1)}
    it {should have_selector('title', text: title)}
  end
    
  #let(:base_title){'Ruby on Rails Tutorial Sample App | '}
  
   describe "Contact page" do
     
    before(:each){visit contact_path}
    let(:h1){'Contact'}
    let(:title) {full_title('Contact')}
    
    it_should_behave_like "all static pages"
  end

  describe "Home page" do
    before(:each) {visit root_path}
    let(:h1){'Sample App'}
    let(:title){'Home'}
    it_should_behave_like "all static pages"
    
    it "should have the right links on the layout" do
      visit root_path
      click_link "About"
      page.should have_selector 'title', text: full_title('About Us')
    end
    
    it {should_not have_selector 'title', text: '| Homex'}  
    
    describe "for signed-in users" do
      let(:user) {FactoryGirl.create(:user)}
      before do 
	FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
	FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
      end
      it "should render on the feed" do 
	user.feed.each do |item|
	  page.should have_selector("li##{item.id}", text: item.content)
	  end
      end
    end
  end

  describe "Help page" do
    before(:each){visit help_path}

    it "should have the h1 'Help'" do
      page.should have_selector('h1', :text => 'Help')
    end

    it "should have the title 'Help'" do
      page.should have_selector('title',
                        :text => full_title('Help'))
    end
  end

  describe 'About Page' do
    before(:each){visit about_path}

    it "should have the h1 'About Us'" do
      page.should have_selector('h1', :text => 'About Us')
    end

    it "should have the title 'About Us'" do
      page.should have_selector('title',
                    :text => full_title('About Us'))
    end
  end
end
