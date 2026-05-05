FactoryBot.define do
  factory :denuncia do
    association :denunciante, factory: :user
    association :motivo
    descricao { Faker::Lorem.sentence }
    status { :pendente }
    conteudo { nil }
    usuario { nil }

    trait :sobre_conteudo do
      association :conteudo
    end

    trait :sobre_usuario do
      association :usuario, factory: :user
    end

    trait :resolvida do
      status { :resolvida }
    end

    trait :ignorada do
      status { :ignorada }
    end
  end
end
