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
  end
end
