class CreateMarcadores < ActiveRecord::Migration[8.1]
  def change
    enable_extension "pg_trgm"

    create_table :marcadores do |t|
      t.string :nome, null: false
      t.text :descricao, null: false, default: ""

      t.timestamps
    end

    add_index :marcadores, :nome, unique: true
  end
end
