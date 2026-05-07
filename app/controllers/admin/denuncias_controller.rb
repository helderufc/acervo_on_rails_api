class Admin::DenunciasController < Admin::BaseController
  before_action :set_denuncia, only: [ :show, :resolver, :ignorar ]

  def index
    denuncias = Denuncia.includes(:denunciante, :motivo, :usuario, conteudo: [:autor, imagem_attachment: :blob])
    denuncias = denuncias.where(status: params[:status]) if params[:status].present?
    denuncias = denuncias.page(params[:page]).per(50)
    render json: DenunciaSerializer.new(denuncias).serializable_hash
  end

  def show
    render json: DenunciaSerializer.new(@denuncia).serializable_hash[:data][:attributes]
  end

  def resolver
    @denuncia.update!(status: :resolvida)
    head :no_content
  end

  def ignorar
    @denuncia.update!(status: :ignorada)
    head :no_content
  end

  private

  def set_denuncia
    @denuncia = Denuncia.find(params[:id])
  end
end
