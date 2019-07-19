FactoryBot.define do
  factory :user, class: User do
    email { Faker::Internet.email }
    password { "password"}
    password_confirmation { "password" }
    confirmed_at { Date.today }
  end

  factory :noadmin, class: User do
    email  {'fabio.bazurto@gmail.com'}
    password  {'password'}
    password_confirmation { "password" }
    confirmed_at { Date.today }    
  end
end
