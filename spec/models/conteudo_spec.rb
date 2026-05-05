require 'rails_helper'

RSpec.describe Conteudo, type: :model do
  describe "validações" do
    it { should validate_presence_of(:titulo) }
    it { should validate_presence_of(:descricao) }
    it { should validate_presence_of(:tipo) }
  end

  describe "enums" do
    it { should define_enum_for(:tipo).with_values(artigo: 0, divulgacao: 1, projeto: 2) }
  end

  describe "associações" do
    it { should belong_to(:autor).class_name("User") }
    it { should have_many(:marcadores_conteudos).class_name("MarcadorConteudo").dependent(:destroy) }
    it { should have_many(:marcadores).through(:marcadores_conteudos) }
    it { should have_many(:denuncias).dependent(:destroy) }
    it { should have_one_attached(:imagem) }
  end

  describe "imagem" do
    it "é inválida para artigo com imagem anexada" do
      conteudo = build(:conteudo, tipo: :artigo)
      conteudo.imagem.attach(
        io: StringIO.new("fake"),
        filename: "foto.jpg",
        content_type: "image/jpeg"
      )
      expect(conteudo).not_to be_valid
      expect(conteudo.errors[:imagem]).to include("não é permitida para artigos")
    end

    it "é válida para projeto com imagem anexada" do
      conteudo = build(:conteudo, tipo: :projeto)
      conteudo.imagem.attach(
        io: StringIO.new("fake"),
        filename: "foto.jpg",
        content_type: "image/jpeg"
      )
      expect(conteudo).to be_valid
    end

    it "é válida para divulgacao com imagem anexada" do
      conteudo = build(:conteudo, tipo: :divulgacao)
      conteudo.imagem.attach(
        io: StringIO.new("fake"),
        filename: "foto.jpg",
        content_type: "image/jpeg"
      )
      expect(conteudo).to be_valid
    end

    it "é válida para projeto sem imagem" do
      conteudo = build(:conteudo, tipo: :projeto)
      expect(conteudo).to be_valid
    end
  end
end
