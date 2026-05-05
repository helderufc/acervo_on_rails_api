FactoryBot.define do
  factory :user do
    nome { Faker::Name.name }
    email { Faker::Internet.unique.email }
    password { "senha123" }
    password_confirmation { "senha123" }
    role { :usuario }
    ativado { true }

    trait :admin do
      role { :admin }
    end

    trait :inativo do
      ativado { false }
    end
  end
end
