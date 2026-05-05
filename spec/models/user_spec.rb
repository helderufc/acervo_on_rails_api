require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validações" do
    it { should validate_presence_of(:nome) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
  end

  describe "enums" do
    it { should define_enum_for(:role).with_values(usuario: 0, admin: 1) }
  end

  describe "associações" do
    it { should have_many(:conteudos).with_foreign_key(:autor_id).dependent(:destroy) }
    it { should have_many(:denuncias_feitas).class_name("Denuncia").with_foreign_key(:denunciante_id) }
    it { should have_many(:denuncias_recebidas).class_name("Denuncia").with_foreign_key(:usuario_id) }
  end

  describe "valores padrão" do
    it "cria usuário com role usuario por padrão" do
      user = create(:user)
      expect(user.usuario?).to be true
    end

    it "cria usuário ativo por padrão" do
      user = create(:user)
      expect(user.ativado).to be true
    end
  end
end
