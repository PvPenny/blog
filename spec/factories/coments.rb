FactoryGirl.define do
  factory :coment, class: 'Coments' do
    text "MyText"
    association(:post)
    association(:user)
  end
end
