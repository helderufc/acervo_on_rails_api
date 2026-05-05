class Auth::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  protected

  def sign_up(resource_name, resource)
    # JWT cuida da autenticação — não usar sessão após registro
  end

  private

  def sign_up_params
    params.require(:user).permit(:nome, :email, :password, :password_confirmation)
  end

  def respond_with(resource, _opts = {})
    if resource.persisted?
      render json: { user: UserSerializer.new(resource).serializable_hash[:data][:attributes] }, status: :created
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
