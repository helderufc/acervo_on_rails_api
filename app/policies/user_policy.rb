class UserPolicy < ApplicationPolicy
  def update? = user == record
  def encerrar? = user == record
  def destroy? = user == record
end
