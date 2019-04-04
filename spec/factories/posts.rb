FactoryGirl.define do
  factory :post do
    text "MyText"
    published true
    user
    tags {FactoryGirl.create_list(:tag, 2)}
  end
end
