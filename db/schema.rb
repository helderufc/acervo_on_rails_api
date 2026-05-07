# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_05_07_124321) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pg_trgm"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "conteudos", force: :cascade do |t|
    t.bigint "autor_id", null: false
    t.datetime "created_at", null: false
    t.text "descricao", null: false
    t.string "links", default: [], array: true
    t.integer "tipo", null: false
    t.string "titulo", null: false
    t.datetime "updated_at", null: false
    t.index ["autor_id"], name: "index_conteudos_on_autor_id"
    t.index ["tipo"], name: "index_conteudos_on_tipo"
    t.index ["titulo"], name: "index_conteudos_on_titulo", opclass: :gin_trgm_ops, using: :gin
  end

  create_table "denuncias", force: :cascade do |t|
    t.bigint "conteudo_id"
    t.datetime "created_at", null: false
    t.bigint "denunciante_id", null: false
    t.text "descricao"
    t.bigint "motivo_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.bigint "usuario_id"
    t.index ["conteudo_id"], name: "index_denuncias_on_conteudo_id"
    t.index ["denunciante_id"], name: "index_denuncias_on_denunciante_id"
    t.index ["motivo_id"], name: "index_denuncias_on_motivo_id"
    t.index ["usuario_id"], name: "index_denuncias_on_usuario_id"
  end

  create_table "jwt_denylist", force: :cascade do |t|
    t.datetime "exp", null: false
    t.string "jti", null: false
    t.index ["jti"], name: "index_jwt_denylist_on_jti"
  end

  create_table "marcadores", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "descricao", default: "", null: false
    t.string "nome", null: false
    t.datetime "updated_at", null: false
    t.index ["nome"], name: "index_marcadores_on_nome", unique: true
  end

  create_table "marcadores_conteudos", id: false, force: :cascade do |t|
    t.bigint "conteudo_id", null: false
    t.bigint "marcador_id", null: false
    t.index ["conteudo_id"], name: "index_marcadores_conteudos_on_conteudo_id"
    t.index ["marcador_id", "conteudo_id"], name: "index_marcadores_conteudos_on_marcador_id_and_conteudo_id", unique: true
    t.index ["marcador_id"], name: "index_marcadores_conteudos_on_marcador_id"
  end

  create_table "motivos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "nome", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.boolean "ativado", default: true, null: false
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "nome", default: "", null: false
    t.integer "role", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "conteudos", "users", column: "autor_id"
  add_foreign_key "denuncias", "conteudos"
  add_foreign_key "denuncias", "motivos"
  add_foreign_key "denuncias", "users", column: "denunciante_id"
  add_foreign_key "denuncias", "users", column: "usuario_id"
  add_foreign_key "marcadores_conteudos", "conteudos"
  add_foreign_key "marcadores_conteudos", "marcadores"
end
