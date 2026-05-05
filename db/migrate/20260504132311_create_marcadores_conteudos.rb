class CreateMarcadoresConteudos < ActiveRecord::Migration[8.1]
  def change
    create_table :marcadores_conteudos, id: false do |t|
      t.references :marcador, null: false, foreign_key: true
      t.references :conteudo, null: false, foreign_key: true
    end

    add_index :marcadores_conteudos, [ :marcador_id, :conteudo_id ], unique: true
  end
end
