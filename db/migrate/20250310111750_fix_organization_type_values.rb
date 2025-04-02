class FixOrganizationTypeValues < ActiveRecord::Migration[7.2]
  def up
    # Update records where organization_type is "2" to "emergency"
    Organization.where(organization_type: "2").update_all(organization_type: "emergency")
    
    # Handle other potential numeric values (from old enum)
    Organization.where(organization_type: "0").update_all(organization_type: "hospital")
    Organization.where(organization_type: "1").update_all(organization_type: "pharmacy")
    
    # Ensure no nil values remain
    Organization.where(organization_type: nil).where.not(emergency_organization_type: nil).update_all(organization_type: "emergency")
    Organization.where(organization_type: nil).update_all(organization_type: "hospital")
  end

  def down
    # Revert to original numeric values if needed
    Organization.where(organization_type: "emergency").update_all(organization_type: "2")
    Organization.where(organization_type: "hospital").update_all(organization_type: "0")
    Organization.where(organization_type: "pharmacy").update_all(organization_type: "1")
  end
end