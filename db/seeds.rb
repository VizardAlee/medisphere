# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
emergency_organizations = [
  { name: "Police", organization_type: "emergency", phone: "1234567890", address: "Police HQ" },
  { name: "Federal Road Safety Commission", organization_type: "emergency", phone: "0987654321", address: "FRSC HQ" },
  { name: "Fire Service", organization_type: "emergency", phone: "1122334455", address: "Fire HQ" }
]

emergency_organizations.each do |org|
  Organization.find_or_create_by(name: org[:name]) do |o|
    o.organization_type = org[:organization_type]
    o.phone = org[:phone]
    o.address = org[:address]
  end
end