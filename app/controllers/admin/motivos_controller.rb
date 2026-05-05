class Admin::MotivosController < Admin::BaseController
  before_action :set_motivo, only: [ :update, :destroy ]

  def index
    render json: MotivoSerializer.new(Motivo.all).serializable_hash
  end

  def create
    motivo = Motivo.new(motivo_params)
    if motivo.save
      render json: MotivoSerializer.new(motivo).serializable_hash[:data][:attributes], status: :created
    else
      render json: { errors: motivo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @motivo.update(motivo_params)
      render json: MotivoSerializer.new(@motivo).serializable_hash[:data][:attributes]
    else
      render json: { errors: @motivo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @motivo.destroy
    head :no_content
  end

  private

  def set_motivo
    @motivo = Motivo.find(params[:id])
  end

  def motivo_params
    params.require(:motivo).permit(:nome)
  end
end
