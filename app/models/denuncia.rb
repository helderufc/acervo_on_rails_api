class Denuncia < ApplicationRecord
  belongs_to :denunciante, class_name: "User"
  belongs_to :motivo
  belongs_to :conteudo, optional: true
  belongs_to :usuario, class_name: "User", optional: true

  enum :status, { pendente: 0, resolvida: 1, ignorada: 2 }

  validates :motivo, presence: true
  validate :deve_ter_alvo

  private

  def deve_ter_alvo
    tem_conteudo = conteudo_id.present? || conteudo.present?
    tem_usuario  = usuario_id.present?  || usuario.present?

    if !tem_conteudo && !tem_usuario
      errors.add(:base, "A denúncia deve ter um conteúdo ou usuário como alvo.")
    elsif tem_conteudo && tem_usuario
      errors.add(:base, "A denúncia deve ter apenas um alvo.")
    end
  end
end
