FactoryGirl.define do
  factory :user do
    name "Michael Hartl"
    email "michael@example.com"
    password "foobar"
    password_confirmation "foobar"
  end
 
  
  factory :user1, class: User do
    name "Jaquan Cooke"
    email "jcooke@gmail.com"
    password "jjqq"
    password_confirmation "jjqq"
  end
end

