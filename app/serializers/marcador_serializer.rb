class MarcadorSerializer
  include JSONAPI::Serializer

  attributes :id, :nome, :descricao
end
