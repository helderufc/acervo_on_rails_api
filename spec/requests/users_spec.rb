require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /users/:id" do
    let!(:user) { create(:user) }

    it "retorna o perfil sem autenticação" do
      get "/users/#{user.id}"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["email"]).to eq(user.email)
    end

    it "retorna 404 para usuário inexistente" do
      get "/users/999999"
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "PUT /users/:id" do
    let!(:user) { create(:user) }
    let!(:outro) { create(:user) }

    it "atualiza o próprio usuário" do
      put "/users/#{user.id}", params: { user: { nome: "Novo Nome" } }, headers: auth_headers_for(user), as: :json
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["nome"]).to eq("Novo Nome")
    end

    it "retorna 403 ao tentar atualizar outro usuário" do
      put "/users/#{outro.id}", params: { user: { nome: "Invasor" } }, headers: auth_headers_for(user), as: :json
      expect(response).to have_http_status(:forbidden)
    end

    it "retorna 401 sem autenticação" do
      put "/users/#{user.id}", params: { user: { nome: "Sem auth" } }, as: :json
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "PATCH /users/:id/encerrar" do
    let!(:user) { create(:user) }

    it "anonimiza o usuário e retorna 204" do
      patch "/users/#{user.id}/encerrar", headers: auth_headers_for(user)
      expect(response).to have_http_status(:no_content)
      expect(user.reload.ativado).to be false
    end

    it "remove conteúdos quando manter_conteudos=false" do
      create(:conteudo, autor: user)
      patch "/users/#{user.id}/encerrar?manter_conteudos=false", headers: auth_headers_for(user)
      expect(user.conteudos.count).to eq(0)
    end

    it "mantém conteúdos quando manter_conteudos=true" do
      create(:conteudo, autor: user)
      patch "/users/#{user.id}/encerrar?manter_conteudos=true", headers: auth_headers_for(user)
      expect(user.conteudos.count).to eq(1)
    end

    it "retorna 403 ao tentar encerrar conta de outro usuário" do
      outro = create(:user)
      patch "/users/#{outro.id}/encerrar", headers: auth_headers_for(user)
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "DELETE /users/:id" do
    let!(:user) { create(:user) }

    it "deleta o próprio usuário e retorna 204" do
      delete "/users/#{user.id}", headers: auth_headers_for(user)
      expect(response).to have_http_status(:no_content)
      expect(User.exists?(user.id)).to be false
    end

    it "retorna 403 ao tentar deletar outro usuário" do
      outro = create(:user)
      delete "/users/#{outro.id}", headers: auth_headers_for(user)
      expect(response).to have_http_status(:forbidden)
    end

    it "retorna 401 sem autenticação" do
      delete "/users/#{user.id}"
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
