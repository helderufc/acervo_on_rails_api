# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :nome,               null: false, default: ""
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.integer :role,              null: false, default: 0
      t.boolean :ativado,           null: false, default: true

      t.timestamps null: false
    end

    add_index :users, :email, unique: true

    create_table :jwt_denylist do |t|
      t.string :jti, null: false
      t.datetime :exp, null: false
    end

    add_index :jwt_denylist, :jti
  end
end
