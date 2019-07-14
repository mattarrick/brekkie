FactoryBot.define do
  factory :user do
    sequence :email do |n|
       "dummyEmail#{n}@gmail.com" 
    end
    password { "secretPassword" }
    password_confirmation { "secretPassword" }
  end

  factory :brek do
    message { "hello" }
    association :user
  end
end