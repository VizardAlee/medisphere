class HealthRecordPolicy < ApplicationPolicy
  def index?
    user.admin? || user.staff? || user.patient? || user.emergency_respondent?
  end

  def show?
    return true if user.admin? || user.staff? || user.emergency_respondent?
    user.patient? && record.patient_id == user.id
  end

  def create?
    user.admin? || user.staff?
  end

  def update?
    user.admin? || user.staff? && record.patient.organization_id == user.organization_id
  end

  def destroy?
    user.admin? && record.patient.organization_id == user.organization_id
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin? || user.staff? || user.emergency_respondent?
        scope.all
      elsif user.patient?
        scope.where(patient_id: user.id)
      else
        scope.none
      end
    end
  end
end
