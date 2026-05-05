require 'rails_helper'

RSpec.describe Denuncia, type: :model do
  describe "enums" do
    it { should define_enum_for(:status).with_values(pendente: 0, resolvida: 1, ignorada: 2) }
  end

  describe "associações" do
    it { should belong_to(:denunciante).class_name("User") }
    it { should belong_to(:motivo) }
    it { should belong_to(:conteudo).optional }
    it { should belong_to(:usuario).class_name("User").optional }
  end

  describe "validação de alvo" do
    let(:denunciante) { create(:user) }
    let(:motivo) { create(:motivo) }

    it "é inválida sem alvo" do
      denuncia = build(:denuncia, denunciante: denunciante, motivo: motivo)
      expect(denuncia).not_to be_valid
      expect(denuncia.errors[:base]).to include("A denúncia deve ter um conteúdo ou usuário como alvo.")
    end

    it "é inválida com dois alvos" do
      denuncia = build(:denuncia, :sobre_conteudo, :sobre_usuario, denunciante: denunciante, motivo: motivo)
      expect(denuncia).not_to be_valid
      expect(denuncia.errors[:base]).to include("A denúncia deve ter apenas um alvo.")
    end

    it "é válida com alvo conteúdo" do
      denuncia = build(:denuncia, :sobre_conteudo, denunciante: denunciante, motivo: motivo)
      expect(denuncia).to be_valid
    end

    it "é válida com alvo usuário" do
      denuncia = build(:denuncia, :sobre_usuario, denunciante: denunciante, motivo: motivo)
      expect(denuncia).to be_valid
    end
  end
end
