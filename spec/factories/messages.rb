# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
    text "MyString"
    type ""
    status "MyString"
    info "MyText"
  end
end
