class ConteudoSerializer
  include JSONAPI::Serializer

  attributes :id, :tipo, :titulo, :descricao, :links, :created_at, :updated_at

  attribute :imagem do |conteudo|
    if conteudo.imagem.attached?
      Rails.application.routes.url_helpers.rails_blob_url(
        conteudo.imagem,
        host: ENV.fetch("ASSET_HOST", "http://localhost:3000")
      )
    end
  end

  belongs_to :autor, serializer: UserSerializer
end
