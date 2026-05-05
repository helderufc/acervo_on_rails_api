class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  enum :role, { usuario: 0, admin: 1 }

  has_many :conteudos, foreign_key: :autor_id, dependent: :destroy
  has_many :denuncias_feitas, class_name: "Denuncia", foreign_key: :denunciante_id, dependent: :destroy
  has_many :denuncias_recebidas, class_name: "Denuncia", foreign_key: :usuario_id, dependent: :destroy

  validates :nome, presence: true
  validates :email, presence: true, uniqueness: true

  def jwt_payload
    { "role" => role }
  end
end
