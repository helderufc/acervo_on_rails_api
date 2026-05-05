require 'rails_helper'

RSpec.describe Marcador, type: :model do
  describe "validações" do
    subject { build(:marcador) }
    it { should validate_presence_of(:nome) }
    it { should validate_presence_of(:descricao) }
    it { should validate_uniqueness_of(:nome).case_insensitive }
  end

  describe "associações" do
    it { should have_many(:marcadores_conteudos).class_name("MarcadorConteudo").dependent(:destroy) }
    it { should have_many(:conteudos).through(:marcadores_conteudos) }
  end

  describe "normalização do nome" do
    it "converte para minúsculo e remove espaços extras" do
      marcador = create(:marcador, nome: "  Design UX  ")
      expect(marcador.nome).to eq("design ux")
    end
  end
end
