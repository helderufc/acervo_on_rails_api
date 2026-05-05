class CreateConteudos < ActiveRecord::Migration[8.1]
  def change
    create_table :conteudos do |t|
      t.references :autor, null: false, foreign_key: { to_table: :users }
      t.integer :tipo, null: false
      t.string :titulo, null: false
      t.text :descricao, null: false
      t.string :imagem
      t.string :links, array: true, default: []

      t.timestamps
    end
  end
end
