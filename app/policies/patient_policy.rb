class PatientPolicy < ApplicationPolicy
  # For the show action: only admins, staff, or the patient themselves can view the record
  def show?
    # Admins and staff can view any patient record
    return true if user.admin? || user.staff?
    
    # A patient can view their own record
    user.patient? && record.id == user.id
  end

  # You can also define other actions (like update?, create?) here if needed
  def update?
    user.admin? || user.staff?
  end

  def edit?
    update?
  end

  def destroy?
    user.admin?
  end

  # You can define more actions as needed...
end
