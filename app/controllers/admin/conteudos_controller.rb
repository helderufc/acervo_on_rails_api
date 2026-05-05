class Admin::ConteudosController < Admin::BaseController
  def destroy
    Conteudo.find(params[:id]).destroy
    head :no_content
  end
end
