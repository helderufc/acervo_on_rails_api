class ConteudoSerializer
  include JSONAPI::Serializer

  attributes :id, :tipo, :titulo, :descricao, :imagem, :links, :created_at, :updated_at

  belongs_to :autor, serializer: UserSerializer
end
