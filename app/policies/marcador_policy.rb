class MarcadorPolicy < ApplicationPolicy
  def update? = user.admin?
  def destroy? = user.admin?
end
