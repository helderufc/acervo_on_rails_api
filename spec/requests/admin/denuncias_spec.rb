require 'rails_helper'

RSpec.describe "Admin::Denuncias", type: :request do
  let!(:admin) { create(:user, :admin) }
  let!(:user) { create(:user) }
  let!(:denuncia) { create(:denuncia, :sobre_conteudo) }

  describe "GET /admin/denuncias" do
    before { create(:denuncia, :sobre_conteudo, :resolvida) }

    it "admin lista todas as denúncias" do
      get "/admin/denuncias", headers: auth_headers_for(admin)
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["data"].length).to eq(2)
    end

    it "filtra por status" do
      get "/admin/denuncias?status=pendente", headers: auth_headers_for(admin)
      expect(JSON.parse(response.body)["data"].length).to eq(1)
    end

    it "retorna 403 para usuário comum" do
      get "/admin/denuncias", headers: auth_headers_for(user)
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "GET /admin/denuncias/:id" do
    it "admin visualiza a denúncia" do
      get "/admin/denuncias/#{denuncia.id}", headers: auth_headers_for(admin)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /admin/denuncias/:id/resolver" do
    it "admin resolve a denúncia" do
      patch "/admin/denuncias/#{denuncia.id}/resolver", headers: auth_headers_for(admin)
      expect(response).to have_http_status(:no_content)
      expect(denuncia.reload.resolvida?).to be true
    end
  end

  describe "PATCH /admin/denuncias/:id/ignorar" do
    it "admin ignora a denúncia" do
      patch "/admin/denuncias/#{denuncia.id}/ignorar", headers: auth_headers_for(admin)
      expect(response).to have_http_status(:no_content)
      expect(denuncia.reload.ignorada?).to be true
    end
  end
end
