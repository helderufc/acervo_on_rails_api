require 'rails_helper'

RSpec.describe "Admin::Motivos", type: :request do
  let!(:admin) { create(:user, :admin) }
  let!(:user) { create(:user) }

  describe "GET /admin/motivos" do
    before { create_list(:motivo, 3) }

    it "admin lista motivos" do
      get "/admin/motivos", headers: auth_headers_for(admin)
      expect(response).to have_http_status(:ok)
    end

    it "retorna 403 para usuário comum" do
      get "/admin/motivos", headers: auth_headers_for(user)
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "POST /admin/motivos" do
    it "admin cria motivo" do
      post "/admin/motivos", params: { motivo: { nome: "Spam" } }, headers: auth_headers_for(admin), as: :json
      expect(response).to have_http_status(:created)
    end

    it "retorna 422 com nome duplicado" do
      create(:motivo, nome: "Spam")
      post "/admin/motivos", params: { motivo: { nome: "Spam" } }, headers: auth_headers_for(admin), as: :json
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PUT /admin/motivos/:id" do
    let!(:motivo) { create(:motivo) }

    it "admin atualiza motivo" do
      put "/admin/motivos/#{motivo.id}", params: { motivo: { nome: "Atualizado" } }, headers: auth_headers_for(admin), as: :json
      expect(response).to have_http_status(:ok)
      expect(motivo.reload.nome).to eq("Atualizado")
    end
  end

  describe "DELETE /admin/motivos/:id" do
    let!(:motivo) { create(:motivo) }

    it "admin remove motivo" do
      delete "/admin/motivos/#{motivo.id}", headers: auth_headers_for(admin)
      expect(response).to have_http_status(:no_content)
      expect(Motivo.exists?(motivo.id)).to be false
    end
  end
end
