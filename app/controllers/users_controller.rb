class UsersController < ApplicationController
  before_action :set_user, only: [ :show, :update, :encerrar ]
  before_action :authenticate_user!, only: [ :update, :encerrar, :destroy ]

  def show
    render json: UserSerializer.new(@user).serializable_hash[:data][:attributes]
  end

  def update
    authorize @user
    if @user.update(user_params)
      render json: UserSerializer.new(@user).serializable_hash[:data][:attributes]
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def encerrar
    authorize @user
    manter_conteudos = params[:manter_conteudos] == "true"
    @user.conteudos.destroy_all unless manter_conteudos
    @user.update!(nome: "Usuário encerrado", email: "encerrado_#{@user.id}@deletado.local", ativado: false)
    sign_out(@user)
    head :no_content
  end

  def destroy
    user = User.find(params[:id])
    authorize user
    user.destroy
    head :no_content
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:nome, :email, :password, :password_confirmation)
  end

  def public_action?
    action_name.in?(%w[show])
  end
end
