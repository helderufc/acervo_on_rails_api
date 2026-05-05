class DenunciasController < ApplicationController
  def create
    denuncia = current_user.denuncias_feitas.build(denuncia_params)
    if denuncia.save
      render json: DenunciaSerializer.new(denuncia).serializable_hash[:data][:attributes], status: :created
    else
      render json: { errors: denuncia.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def denuncia_params
    params.require(:denuncia).permit(:motivo_id, :descricao, :conteudo_id, :usuario_id)
  end
end
