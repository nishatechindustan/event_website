FactoryBot.define do
  factory :user do
  	user_name "A"
    first_name "Ashish"
    last_name "Mishra"
    email "a@gmail.com"
    is_admin false
    password "123456"
    password_confirmation "123456"
  end
end
