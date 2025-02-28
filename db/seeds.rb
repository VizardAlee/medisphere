# db/seeds.rb

states = [
  "Abia", "Adamawa", "Akwa Ibom", "Anambra", "Bauchi", "Bayelsa", "Benue", "Borno",
  "Cross River", "Delta", "Ebonyi", "Edo", "Ekiti", "Enugu", "FCT", "Gombe",
  "Imo", "Jigawa", "Kaduna", "Kano", "Katsina", "Kebbi", "Kogi", "Kwara", "Lagos",
  "Nasarawa", "Niger", "Ogun", "Ondo", "Osun", "Oyo", "Plateau", "Rivers",
  "Sokoto", "Taraba", "Yobe", "Zamfara"
]

emergency_organizations = ["Police", "Road Safety", "Fire Service"]

# Ensure an emergency organization exists
# Ensure an emergency organization exists with required fields
emergency_org = Organization.find_or_create_by!(
  name: "Emergency Response",
  organization_type: "emergency",
  address: "No. 1 Emergency Street, Abuja",
  phone: "08000000000"
)

states.each do |state|
  emergency_organizations.each do |org|
    user_email = "#{org.downcase.gsub(' ', '_')}_admin_#{state.downcase.gsub(' ', '_')}@medisphere.com"

    user = User.where(email: user_email).first_or_initialize

    user.phone ||= "080#{rand(1_000_000..9_999_999)}"
    user.role  = :super_admin
    user.state = state
    user.emergency_organization_type = org
    user.organization_id = emergency_org.id # Assign the emergency organization
    user.password = "123456"
    user.password_confirmation = "123456"

    user.save!
  end
end

puts "Super Admins seeded successfully!"



puts "✅ Super Admins seeded successfully!"
