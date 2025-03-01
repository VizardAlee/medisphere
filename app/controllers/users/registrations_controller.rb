class Users::RegistrationsController < Devise::RegistrationsController
  def new
    super do |resource|
      # Define states array for the view
      @states = [
        "Abia", "Adamawa", "Akwa Ibom", "Anambra", "Bauchi", "Bayelsa", "Benue", "Borno",
        "Cross River", "Delta", "Ebonyi", "Edo", "Ekiti", "Enugu", "FCT", "Gombe",
        "Imo", "Jigawa", "Kaduna", "Kano", "Katsina", "Kebbi", "Kogi", "Kwara", "Lagos",
        "Nasarawa", "Niger", "Ogun", "Ondo", "Osun", "Oyo", "Plateau", "Rivers",
        "Sokoto", "Taraba", "Yobe", "Zamfara"
      ]
      @emergency_organizations = ["Police", "Road Safety", "Fire Service"]
    end
  end

  def create
    logger.debug "Sign-up params: #{params.inspect}"
    build_resource(sign_up_params)

    # Create and save the organization first
    organization = Organization.new(
      name: params[:organization_name],
      address: params[:organization_address],
      phone: params[:organization_phone],
      organization_type: params[:organization_type],
      state: params[:state].presence,
      emergency_organization_type: params[:emergency_organization_type].presence
    )

    # Wrap in a transaction to ensure both save or neither does
    ActiveRecord::Base.transaction do
      if organization.save
        resource.organization = organization
        resource.role = "admin"

        if resource.save
          logger.debug "User and organization saved successfully"
          if resource.active_for_authentication?
            set_flash_message! :notice, :signed_up
            sign_up(resource_name, resource)
            respond_with resource, location: after_sign_up_path_for(resource)
          else
            set_flash_message! :notice, :signed_up_but_inactive
            expire_data_after_sign_in!
            respond_with resource, location: after_inactive_sign_up_path_for(resource)
          end
        else
          logger.debug "Failed to save user: #{resource.errors.full_messages}"
          raise ActiveRecord::Rollback # Roll back if user fails
        end
      else
        logger.debug "Failed to save organization: #{organization.errors.full_messages}"
        raise ActiveRecord::Rollback # Roll back if organization fails
      end
    end

    # If transaction fails, handle errors
    unless performed? # Check if response already sent
      clean_up_passwords resource
      set_minimum_password_length
      resource.errors.add(:base, "Failed to create organization or user") unless resource.errors.any?
      respond_with resource
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :phone, :password, :password_confirmation])
  end

  def after_sign_up_path_for(resource)
    root_path
  end
end

