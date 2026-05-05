class Marcador < ApplicationRecord
  has_many :marcadores_conteudos, class_name: "MarcadorConteudo", dependent: :destroy
  has_many :conteudos, through: :marcadores_conteudos

  validates :nome, presence: true, uniqueness: true
  validates :descricao, presence: true

  before_validation { self.nome = nome&.downcase&.strip }
end
