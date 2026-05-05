FactoryBot.define do
  factory :marcador do
    nome { Faker::Lorem.unique.word.downcase }
    descricao { Faker::Lorem.sentence }
  end
end
