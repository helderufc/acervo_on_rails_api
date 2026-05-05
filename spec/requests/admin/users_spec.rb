require 'rails_helper'

RSpec.describe "Admin::Users", type: :request do
  let!(:admin) { create(:user, :admin) }
  let!(:user) { create(:user) }

  describe "PATCH /admin/users/:id/desativar" do
    it "admin desativa o usuário" do
      patch "/admin/users/#{user.id}/desativar", headers: auth_headers_for(admin)
      expect(response).to have_http_status(:no_content)
      expect(user.reload.ativado).to be false
    end

    it "retorna 403 para usuário comum" do
      patch "/admin/users/#{user.id}/desativar", headers: auth_headers_for(user)
      expect(response).to have_http_status(:forbidden)
    end

    it "retorna 401 sem autenticação" do
      patch "/admin/users/#{user.id}/desativar"
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "PATCH /admin/users/:id/reativar" do
    before { user.update!(ativado: false) }

    it "admin reativa o usuário" do
      patch "/admin/users/#{user.id}/reativar", headers: auth_headers_for(admin)
      expect(response).to have_http_status(:no_content)
      expect(user.reload.ativado).to be true
    end
  end

  describe "PATCH /admin/users/:id/promover" do
    it "admin promove usuário" do
      patch "/admin/users/#{user.id}/promover", headers: auth_headers_for(admin)
      expect(response).to have_http_status(:no_content)
      expect(user.reload.admin?).to be true
    end
  end

  describe "PATCH /admin/users/:id/revogar" do
    let!(:outro_admin) { create(:user, :admin) }

    it "admin revoga papel de outro admin" do
      patch "/admin/users/#{outro_admin.id}/revogar", headers: auth_headers_for(admin)
      expect(response).to have_http_status(:no_content)
      expect(outro_admin.reload.usuario?).to be true
    end

    it "retorna 422 ao tentar revogar o próprio papel" do
      patch "/admin/users/#{admin.id}/revogar", headers: auth_headers_for(admin)
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
