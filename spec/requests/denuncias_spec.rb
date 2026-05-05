require 'rails_helper'

RSpec.describe "Denuncias", type: :request do
  let!(:user) { create(:user) }
  let!(:motivo) { create(:motivo) }

  describe "POST /denuncias" do
    context "denunciando conteúdo" do
      let!(:conteudo) { create(:conteudo) }

      it "cria a denúncia com status pendente" do
        post "/denuncias", params: { denuncia: { motivo_id: motivo.id, conteudo_id: conteudo.id, descricao: "Inapropriado" } }, headers: auth_headers_for(user), as: :json
        expect(response).to have_http_status(:created)
        expect(Denuncia.last.pendente?).to be true
      end
    end

    context "denunciando usuário" do
      let!(:alvo) { create(:user) }

      it "cria a denúncia contra o usuário" do
        post "/denuncias", params: { denuncia: { motivo_id: motivo.id, usuario_id: alvo.id } }, headers: auth_headers_for(user), as: :json
        expect(response).to have_http_status(:created)
      end
    end

    it "retorna 422 sem alvo" do
      post "/denuncias", params: { denuncia: { motivo_id: motivo.id } }, headers: auth_headers_for(user), as: :json
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "retorna 422 com dois alvos" do
      conteudo = create(:conteudo)
      alvo = create(:user)
      post "/denuncias", params: { denuncia: { motivo_id: motivo.id, conteudo_id: conteudo.id, usuario_id: alvo.id } }, headers: auth_headers_for(user), as: :json
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "retorna 401 sem autenticação" do
      post "/denuncias", params: { denuncia: { motivo_id: motivo.id } }, as: :json
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
