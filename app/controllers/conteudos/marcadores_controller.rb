class Conteudos::MarcadoresController < ApplicationController
  before_action :set_conteudo

  def index
    render json: MarcadorSerializer.new(@conteudo.marcadores).serializable_hash
  end

  def create
    authorize @conteudo, :update?
    marcadores = Marcador.where(id: params[:marcador_ids])
    @conteudo.marcadores << marcadores - @conteudo.marcadores
    render json: MarcadorSerializer.new(@conteudo.marcadores).serializable_hash
  end

  def destroy
    authorize @conteudo, :update?
    marcador = @conteudo.marcadores.find(params[:marcador_id])
    @conteudo.marcadores.delete(marcador)
    head :no_content
  end

  private

  def set_conteudo
    @conteudo = Conteudo.find(params[:conteudo_id] || params[:id])
  end

  def public_action?
    action_name == "index"
  end
end
