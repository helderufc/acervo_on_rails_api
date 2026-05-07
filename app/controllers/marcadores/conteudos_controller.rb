class Marcadores::ConteudosController < ApplicationController
  def index
    marcador = Marcador.find(params[:marcador_id])
    conteudos = marcador.conteudos.includes(:autor, imagem_attachment: :blob).page(params[:page]).per(per_page_param)
    render json: ConteudoSerializer.new(conteudos).serializable_hash
  end

  def public_action?
    true
  end

  private

  def per_page_param
    per = params[:per_page].to_i
    per.between?(1, 100) ? per : 20
  end
end
