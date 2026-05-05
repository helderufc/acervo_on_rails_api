class CreateDenuncias < ActiveRecord::Migration[8.1]
  def change
    create_table :denuncias do |t|
      t.references :denunciante, null: false, foreign_key: { to_table: :users }
      t.references :motivo, null: false, foreign_key: true
      t.text :descricao
      t.integer :status, null: false, default: 0
      t.references :conteudo, foreign_key: true
      t.references :usuario, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
