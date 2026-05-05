class Admin::BaseController < ApplicationController
  before_action :require_admin!

  private

  def require_admin!
    render json: { error: "Acesso negado." }, status: :forbidden unless current_user&.admin?
  end
end
