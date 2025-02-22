class HealthRecordPolicy < ApplicationPolicy
  def index?
    return true if user_is_admin_or_staff? || user_is_patient? || user_is_emergency_respondent?
  end
  

  def show?
    return true if user_is_admin_or_staff? || user_is_emergency_respondent?
    user_is_patient? && record.patient_id == user.id
  end

  def create?
    user_is_admin_or_staff?
  end

  def update?
    user_is_admin_or_staff? && record.patient.organization_id == user.organization_id
  end

  def destroy?
    user_is_admin? && record.patient.organization_id == user.organization_id
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.none if user.nil?  

      if user_is_admin_or_staff? || user_is_emergency_respondent?
        scope.all
      elsif user_is_patient?
        scope.where(patient_id: user.id)
      else
        scope.none
      end
    end
  end  

  private

  def user_is_admin_or_staff?
    user.respond_to?(:admin?) && (user.admin? || user.staff?)
  end

  def user_is_emergency_respondent?
    user.respond_to?(:emergency_respondent?) && user.emergency_respondent?
  end

  def user_is_patient?
    user.is_a?(Patient) # Ensures we're dealing with a patient object
  end
  
end
