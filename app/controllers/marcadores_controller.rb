class MarcadoresController < ApplicationController
  before_action :set_marcador, only: [ :show, :update, :destroy ]

  def index
    render json: MarcadorSerializer.new(Marcador.all).serializable_hash
  end

  def show
    render json: MarcadorSerializer.new(@marcador).serializable_hash[:data][:attributes]
  end

  def create
    marcador = Marcador.find_or_initialize_by(nome: params.dig(:marcador, :nome)&.downcase&.strip)
    marcador.assign_attributes(marcador_params)
    if marcador.save
      render json: MarcadorSerializer.new(marcador).serializable_hash[:data][:attributes], status: :created
    else
      render json: { errors: marcador.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    authorize @marcador
    if @marcador.update(marcador_params)
      render json: MarcadorSerializer.new(@marcador).serializable_hash[:data][:attributes]
    else
      render json: { errors: @marcador.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @marcador
    @marcador.destroy
    head :no_content
  end

  private

  def set_marcador
    @marcador = Marcador.find(params[:id])
  end

  def marcador_params
    params.require(:marcador).permit(:nome, :descricao)
  end

  def public_action?
    action_name.in?(%w[index show])
  end
end
