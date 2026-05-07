class AddPerformanceIndexesToConteudos < ActiveRecord::Migration[8.1]
  def change
    add_index :conteudos, :tipo
    add_index :conteudos, :titulo, using: :gin, opclass: :gin_trgm_ops
  end
end
