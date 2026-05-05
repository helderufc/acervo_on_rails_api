FactoryBot.define do
  factory :motivo do
    nome { Faker::Lorem.unique.word }
  end
end
