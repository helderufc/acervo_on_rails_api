class ConteudosController < ApplicationController
  before_action :set_conteudo, only: [ :show, :update, :destroy ]

  def index
    conteudos = Conteudo.all
    conteudos = conteudos.where(tipo: params[:tipo]) if params[:tipo].present?
    conteudos = conteudos.where(autor_id: params[:autor_id]) if params[:autor_id].present?
    conteudos = conteudos.joins(:marcadores).where(marcadores: { id: params[:marcador_id] }) if params[:marcador_id].present?
    conteudos = conteudos.com_marcadores_ids(params[:marcador_ids]) if params[:marcador_ids].present?
    conteudos = conteudos.com_marcadores_nomes(params[:marcadores]) if params[:marcadores].present?
    conteudos = conteudos.where("titulo ILIKE ?", "%#{params[:q]}%") if params[:q].present?
    conteudos = conteudos.page(params[:page]).per(params[:per_page] || 20)

    render json: ConteudoSerializer.new(conteudos).serializable_hash
  end

  def show
    render json: ConteudoSerializer.new(@conteudo).serializable_hash[:data][:attributes]
  end

  def create
    conteudo = current_user.conteudos.build(conteudo_params)
    if conteudo.save
      render json: ConteudoSerializer.new(conteudo).serializable_hash[:data][:attributes], status: :created
    else
      render json: { errors: conteudo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    authorize @conteudo
    if @conteudo.update(conteudo_params)
      render json: ConteudoSerializer.new(@conteudo).serializable_hash[:data][:attributes]
    else
      render json: { errors: @conteudo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @conteudo
    @conteudo.destroy
    head :no_content
  end

  private

  def set_conteudo
    @conteudo = Conteudo.find(params[:id])
  end

  def conteudo_params
    params.require(:conteudo).permit(:tipo, :titulo, :descricao, :imagem, links: [])
  end

  def public_action?
    action_name.in?(%w[index show])
  end
end
