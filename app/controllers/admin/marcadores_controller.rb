class Admin::MarcadoresController < Admin::BaseController
  def destroy
    Marcador.find(params[:id]).destroy
    head :no_content
  end
end
