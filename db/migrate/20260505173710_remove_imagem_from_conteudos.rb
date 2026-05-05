class RemoveImagemFromConteudos < ActiveRecord::Migration[8.1]
  def change
    remove_column :conteudos, :imagem, :string
  end
end
