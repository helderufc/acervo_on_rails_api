class ApplicationController < ActionController::API
  include Pundit::Authorization

  before_action :authenticate_user!, unless: :public_action?

  rescue_from Pundit::NotAuthorizedError, with: :forbidden
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

  def public_action?
    false
  end

  def forbidden
    render json: { error: "Acesso negado." }, status: :forbidden
  end

  def not_found
    render json: { error: "Recurso não encontrado." }, status: :not_found
  end
end
