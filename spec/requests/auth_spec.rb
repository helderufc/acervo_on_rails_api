require 'rails_helper'

RSpec.describe "Auth", type: :request do
  describe "POST /auth/signup" do
    let(:params) do
      { user: { nome: "Fulano", email: "fulano@email.com", password: "senha123", password_confirmation: "senha123" } }
    end

    it "cria o usuário e retorna 201" do
      post "/auth/signup", params: params, as: :json
      expect(response).to have_http_status(:created)
    end

    it "retorna os dados do usuário" do
      post "/auth/signup", params: params, as: :json
      expect(JSON.parse(response.body).dig("user", "email")).to eq("fulano@email.com")
    end

    it "retorna 422 com email duplicado" do
      create(:user, email: "fulano@email.com")
      post "/auth/signup", params: params, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "retorna 422 sem nome" do
      post "/auth/signup", params: { user: params[:user].merge(nome: "") }, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "POST /auth/login" do
    let!(:user) { create(:user, email: "user@email.com", password: "senha123") }

    it "retorna 200 e o token no header Authorization" do
      post "/auth/login", params: { user: { email: "user@email.com", password: "senha123" } }, as: :json
      expect(response).to have_http_status(:ok)
      expect(response.headers["Authorization"]).to be_present
    end

    it "retorna 401 com senha errada" do
      post "/auth/login", params: { user: { email: "user@email.com", password: "errada" } }, as: :json
      expect(response).to have_http_status(:unauthorized)
    end

    it "retorna 401 com email inexistente" do
      post "/auth/login", params: { user: { email: "naoexiste@email.com", password: "senha123" } }, as: :json
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "DELETE /auth/logout" do
    let!(:user) { create(:user) }

    it "invalida o token e retorna 204" do
      delete "/auth/logout", headers: auth_headers_for(user)
      expect(response).to have_http_status(:no_content)
    end

    it "retorna 401 sem token" do
      delete "/auth/logout"
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
