FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}   
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end
  factory :micropost do
    content "Lorem ipsum"
    user
  end
  
  factory :user1, class: User do
    name "Jaquan Cooke"
    email "jcooke@gmail.com"
    password "jj44qq"
    password_confirmation "jj44qq"
  end
end


