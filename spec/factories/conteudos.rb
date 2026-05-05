FactoryBot.define do
  factory :conteudo do
    association :autor, factory: :user
    tipo { :artigo }
    titulo { Faker::Lorem.sentence(word_count: 4) }
    descricao { Faker::Lorem.paragraph }
    imagem { nil }
    links { [] }

    trait :divulgacao do
      tipo { :divulgacao }
    end

    trait :projeto do
      tipo { :projeto }
    end
  end
end
