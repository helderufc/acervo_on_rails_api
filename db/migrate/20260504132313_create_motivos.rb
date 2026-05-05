class CreateMotivos < ActiveRecord::Migration[8.1]
  def change
    create_table :motivos do |t|
      t.string :nome, null: false

      t.timestamps
    end
  end
end
