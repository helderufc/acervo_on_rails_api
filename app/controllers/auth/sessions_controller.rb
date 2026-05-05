class Auth::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    render json: { user: UserSerializer.new(resource).serializable_hash[:data][:attributes] }, status: :ok
  end

  def respond_to_on_destroy(_resource_or_scope)
    if request.headers["Authorization"].present?
      head :no_content
    else
      head :unauthorized
    end
  end
end
