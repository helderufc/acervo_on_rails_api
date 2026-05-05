class UserSerializer
  include JSONAPI::Serializer

  attributes :id, :nome, :email, :role, :ativado, :created_at
end
