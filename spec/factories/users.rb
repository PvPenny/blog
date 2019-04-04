FactoryGirl.define do
  factory :user do
    sequence(:uid){|i|"test#{i}@test.ru"}
    sequence(:email){|i|"test#{i}@test.ru"}
    sequence(:nickname){|i|"test#{i}"}
    password 'password'
  end
end
