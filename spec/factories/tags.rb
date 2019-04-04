FactoryGirl.define do
  factory :tag do
    sequence(:name){|i| "tag#{i}" }
  end
end
