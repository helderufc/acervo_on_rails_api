class MarcadorConteudo < ApplicationRecord
  self.table_name = "marcadores_conteudos"

  belongs_to :marcador
  belongs_to :conteudo
end
