class Admin::UsersController < Admin::BaseController
  before_action :set_user

  def desativar
    @user.update!(ativado: false)
    head :no_content
  end

  def reativar
    @user.update!(ativado: true)
    head :no_content
  end

  def promover
    @user.update!(role: :admin)
    head :no_content
  end

  def revogar
    render json: { error: "Não é possível revogar seu próprio papel." }, status: :unprocessable_entity and return if @user == current_user
    @user.update!(role: :usuario)
    head :no_content
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
