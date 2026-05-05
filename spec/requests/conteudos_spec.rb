require 'rails_helper'

RSpec.describe "Conteudos", type: :request do
  describe "GET /conteudos" do
    before { create_list(:conteudo, 3) }

    it "retorna a lista sem autenticação" do
      get "/conteudos"
      expect(response).to have_http_status(:ok)
    end

    it "filtra por tipo" do
      create(:conteudo, :projeto)
      get "/conteudos?tipo=projeto"
      ids = JSON.parse(response.body)["data"].map { |c| c["id"] }
      expect(ids.length).to eq(1)
    end

    it "filtra por autor_id" do
      autor = create(:user)
      create(:conteudo, autor: autor)
      get "/conteudos?autor_id=#{autor.id}"
      expect(JSON.parse(response.body)["data"].length).to eq(1)
    end

    it "busca por título" do
      create(:conteudo, titulo: "Rails para iniciantes")
      get "/conteudos?q=iniciantes"
      titulos = JSON.parse(response.body)["data"].map { |c| c.dig("attributes", "titulo") }
      expect(titulos).to include("Rails para iniciantes")
    end
  end

  describe "GET /conteudos/:id" do
    let!(:conteudo) { create(:conteudo) }

    it "retorna o conteúdo sem autenticação" do
      get "/conteudos/#{conteudo.id}"
      expect(response).to have_http_status(:ok)
    end

    it "retorna 404 para conteúdo inexistente" do
      get "/conteudos/999999"
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /conteudos" do
    let!(:user) { create(:user) }
    let(:params) { { conteudo: { tipo: "artigo", titulo: "Título", descricao: "Descrição" } } }

    it "cria o conteúdo autenticado" do
      post "/conteudos", params: params, headers: auth_headers_for(user), as: :json
      expect(response).to have_http_status(:created)
    end

    it "associa o conteúdo ao usuário logado" do
      post "/conteudos", params: params, headers: auth_headers_for(user), as: :json
      expect(Conteudo.last.autor).to eq(user)
    end

    it "retorna 401 sem autenticação" do
      post "/conteudos", params: params, as: :json
      expect(response).to have_http_status(:unauthorized)
    end

    it "retorna 422 sem título" do
      post "/conteudos", params: { conteudo: params[:conteudo].merge(titulo: "") }, headers: auth_headers_for(user), as: :json
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PUT /conteudos/:id" do
    let!(:user) { create(:user) }
    let!(:outro) { create(:user) }
    let!(:conteudo) { create(:conteudo, autor: user) }

    it "atualiza o próprio conteúdo" do
      put "/conteudos/#{conteudo.id}", params: { conteudo: { titulo: "Atualizado" } }, headers: auth_headers_for(user), as: :json
      expect(response).to have_http_status(:ok)
      expect(conteudo.reload.titulo).to eq("Atualizado")
    end

    it "retorna 403 ao editar conteúdo de outro" do
      put "/conteudos/#{conteudo.id}", params: { conteudo: { titulo: "Invasão" } }, headers: auth_headers_for(outro), as: :json
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "DELETE /conteudos/:id" do
    let!(:user) { create(:user) }
    let!(:outro) { create(:user) }
    let!(:conteudo) { create(:conteudo, autor: user) }

    it "deleta o próprio conteúdo" do
      delete "/conteudos/#{conteudo.id}", headers: auth_headers_for(user)
      expect(response).to have_http_status(:no_content)
    end

    it "retorna 403 ao deletar conteúdo de outro" do
      delete "/conteudos/#{conteudo.id}", headers: auth_headers_for(outro)
      expect(response).to have_http_status(:forbidden)
    end

    it "retorna 401 sem autenticação" do
      delete "/conteudos/#{conteudo.id}"
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
