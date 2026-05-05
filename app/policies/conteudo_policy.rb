class ConteudoPolicy < ApplicationPolicy
  def update? = user == record.autor
  def destroy? = user == record.autor
end
