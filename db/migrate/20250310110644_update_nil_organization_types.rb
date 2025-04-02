class UpdateNilOrganizationTypes < ActiveRecord::Migration[7.2]
  def change
    def up
      # Update organizations where organization_type is nil and emergency_organization_type is present
      Organization.where(organization_type: nil).where.not(emergency_organization_type: nil).update_all(organization_type: "emergency")
      
      # Optional: Set remaining nil organization_types to "hospital" as a fallback
      Organization.where(organization_type: nil).update_all(organization_type: "hospital")
    end
  
    def down
      # Reset to nil if rolling back (optional, depending on your needs)
      Organization.where(organization_type: "emergency").where.not(emergency_organization_type: nil).update_all(organization_type: nil)
      Organization.where(organization_type: "hospital").update_all(organization_type: nil)
    end
  end
end
