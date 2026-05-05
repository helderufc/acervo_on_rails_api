class Conteudo < ApplicationRecord
  belongs_to :autor, class_name: "User"
  has_many :marcadores_conteudos, class_name: "MarcadorConteudo", dependent: :destroy
  has_many :marcadores, through: :marcadores_conteudos
  has_many :denuncias, dependent: :destroy

  enum :tipo, { artigo: 0, divulgacao: 1, projeto: 2 }

  validates :titulo, :descricao, :tipo, presence: true
end
