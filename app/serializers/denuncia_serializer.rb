class DenunciaSerializer
  include JSONAPI::Serializer

  attributes :id, :status, :descricao, :created_at

  belongs_to :denunciante, serializer: UserSerializer
  belongs_to :motivo, serializer: MotivoSerializer
  belongs_to :conteudo, serializer: ConteudoSerializer, if: proc { |r| r.conteudo_id.present? }
  belongs_to :usuario, serializer: UserSerializer, if: proc { |r| r.usuario_id.present? }
end
