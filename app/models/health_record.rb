class HealthRecord < ApplicationRecord
  belongs_to :patient

  def create?
    user.admin? || user.staff?
  end

  def update?
    user.admin? || user.staff?
  end

  def show?
    user.admin? || user.staff? || (user.patient? && record.patient_id == user.id) || user.emergency_respondent?
  end

  def destroy?
    user.admin?
  end
end
