class PatientPolicy < ApplicationPolicy
  # For the show action: only admins, staff, or the patient themselves can view the record
  def show?
    user_is_patient? || user_is_admin_or_staff?
  end

  # You can also define other actions (like update?, create?) here if needed
  def update?
    user_is_admin_or_staff?
  end

  def edit?
    update?
  end

  def destroy?
    user.admin?
  end

  private

  def user_is_admin_or_staff?
    # Admin or staff can access based on the same organization
    user.is_a?(User) && (user.admin? || (user.staff? && same_organization?))
  end

  def same_organization?
    user.organization_id == record.organization_id
  end

  def user_is_patient?
    user.is_a?(Patient) &&  user.id == record.user_id
  end

  # You can define more actions as needed...
end
