class Conteudo < ApplicationRecord
  belongs_to :autor, class_name: "User"
  has_many :marcadores_conteudos, class_name: "MarcadorConteudo", dependent: :destroy
  has_many :marcadores, through: :marcadores_conteudos
  has_many :denuncias, dependent: :destroy
  has_one_attached :imagem

  enum :tipo, { artigo: 0, divulgacao: 1, projeto: 2 }

  validates :titulo, :descricao, :tipo, presence: true
  validate :imagem_somente_para_projeto_ou_divulgacao
  validate :links_no_maximo_tres

  scope :com_marcadores_ids, ->(ids) {
    joins(:marcadores).where(marcadores: { id: ids }).distinct
  }

  scope :com_marcadores_nomes, ->(nomes) {
    joins(:marcadores)
      .where(marcadores: { nome: Array(nomes).map { |n| n.downcase.strip } })
      .distinct
  }

  private

  def imagem_somente_para_projeto_ou_divulgacao
    errors.add(:imagem, "não é permitida para artigos") if imagem.attached? && artigo?
  end

  def links_no_maximo_tres
    errors.add(:links, "pode ter no máximo 3 links") if links.length > 3
  end
end
