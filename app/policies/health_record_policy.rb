class HealthRecordPolicy < ApplicationPolicy
  # NOTE: Up to Pundit v2.3.1, the inheritance was declared as
  # `Scope < Scope` rather than `Scope < ApplicationPolicy::Scope`.
  # In most cases the behavior will be identical, but if updating existing
  # code, beware of possible changes to the ancestors:
  # https://gist.github.com/Burgestrand/4b4bc22f31c8a95c425fc0e30d7ef1f5

  def index?
    user.admin? || user.staff? || user.patient?
  end

  def show?
    user.admin? || user.staff? || (user.patient? && record.patient_id == user.id) || user.emergency_respondent?
  end

  def create?
    user.admin? || user.staff?
  end

  def update?
    user.admin? || user.staff?
  end

  def destroy?
    user.admin?
  end

  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      if user.admin? || user.staff?
        scope.all
      elsif user.patient?
        scope.where(patient_id: user.id)
      elsif user.emergency_respondent?
        scope.all
      else
        scope.none
      end
    end
  end
end
