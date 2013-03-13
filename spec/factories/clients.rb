# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :client do
    name "MyString"
    phone "MyString"
    account_balance "9.99"
    advance_payment "9.99"
    total_amount_of_purchases "9.99"
    is_whole_sale_customer "MyString"
  end
end
