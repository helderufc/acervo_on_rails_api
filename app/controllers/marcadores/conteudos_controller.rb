class Marcadores::ConteudosController < ApplicationController
  def index
    marcador = Marcador.find(params[:marcador_id])
    conteudos = marcador.conteudos.page(params[:page]).per(params[:per_page] || 20)
    render json: ConteudoSerializer.new(conteudos).serializable_hash
  end

  def public_action?
    true
  end
end
