class Motivo < ApplicationRecord
  has_many :denuncias

  validates :nome, presence: true, uniqueness: true
end
