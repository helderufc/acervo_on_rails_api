require 'rails_helper'

RSpec.describe "Marcadores", type: :request do
  describe "GET /marcadores" do
    before { create_list(:marcador, 3) }

    it "retorna a lista sem autenticação" do
      get "/marcadores"
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /marcadores/:id" do
    let!(:marcador) { create(:marcador) }

    it "retorna o marcador" do
      get "/marcadores/#{marcador.id}"
      expect(response).to have_http_status(:ok)
    end

    it "retorna 404 para marcador inexistente" do
      get "/marcadores/999999"
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /marcadores" do
    let!(:user) { create(:user) }

    it "cria o marcador autenticado" do
      post "/marcadores", params: { marcador: { nome: "design", descricao: "Conteúdos de design" } }, headers: auth_headers_for(user), as: :json
      expect(response).to have_http_status(:created)
    end

    it "normaliza o nome para minúsculo" do
      post "/marcadores", params: { marcador: { nome: "  DESIGN  ", descricao: "Desc" } }, headers: auth_headers_for(user), as: :json
      expect(Marcador.last.nome).to eq("design")
    end

    it "reutiliza marcador existente com mesmo nome" do
      create(:marcador, nome: "design")
      expect {
        post "/marcadores", params: { marcador: { nome: "design", descricao: "Outro desc" } }, headers: auth_headers_for(user), as: :json
      }.not_to change(Marcador, :count)
    end

    it "retorna 401 sem autenticação" do
      post "/marcadores", params: { marcador: { nome: "novo", descricao: "Desc" } }, as: :json
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "PUT /marcadores/:id" do
    let!(:admin) { create(:user, :admin) }
    let!(:user) { create(:user) }
    let!(:marcador) { create(:marcador) }

    it "admin atualiza o marcador" do
      put "/marcadores/#{marcador.id}", params: { marcador: { nome: "atualizado", descricao: "Nova desc" } }, headers: auth_headers_for(admin), as: :json
      expect(response).to have_http_status(:ok)
    end

    it "retorna 403 para usuário comum" do
      put "/marcadores/#{marcador.id}", params: { marcador: { nome: "hack" } }, headers: auth_headers_for(user), as: :json
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "DELETE /marcadores/:id" do
    let!(:admin) { create(:user, :admin) }
    let!(:user) { create(:user) }
    let!(:marcador) { create(:marcador) }

    it "admin remove o marcador" do
      delete "/marcadores/#{marcador.id}", headers: auth_headers_for(admin)
      expect(response).to have_http_status(:no_content)
    end

    it "retorna 403 para usuário comum" do
      delete "/marcadores/#{marcador.id}", headers: auth_headers_for(user)
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "GET /marcadores/:id/conteudos" do
    let!(:marcador) { create(:marcador) }
    let!(:conteudo) { create(:conteudo) }

    before { marcador.conteudos << conteudo }

    it "retorna os conteúdos do marcador sem autenticação" do
      get "/marcadores/#{marcador.id}/conteudos"
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /conteudos/:id/marcadores" do
    let!(:user) { create(:user) }
    let!(:conteudo) { create(:conteudo, autor: user) }
    let!(:marcador) { create(:marcador) }

    it "adiciona marcador ao conteúdo" do
      post "/conteudos/#{conteudo.id}/marcadores", params: { marcador_ids: [ marcador.id ] }, headers: auth_headers_for(user), as: :json
      expect(response).to have_http_status(:ok)
      expect(conteudo.marcadores).to include(marcador)
    end

    it "retorna 403 se não for autor do conteúdo" do
      outro = create(:user)
      post "/conteudos/#{conteudo.id}/marcadores", params: { marcador_ids: [ marcador.id ] }, headers: auth_headers_for(outro), as: :json
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "DELETE /conteudos/:id/marcadores/:marcador_id" do
    let!(:user) { create(:user) }
    let!(:conteudo) { create(:conteudo, autor: user) }
    let!(:marcador) { create(:marcador) }

    before { conteudo.marcadores << marcador }

    it "remove marcador do conteúdo" do
      delete "/conteudos/#{conteudo.id}/marcadores/#{marcador.id}", headers: auth_headers_for(user)
      expect(response).to have_http_status(:no_content)
      expect(conteudo.marcadores.reload).not_to include(marcador)
    end
  end
end
