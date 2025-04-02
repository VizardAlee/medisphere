# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  def new
    super do |resource|
      @states = ["Abia", "Adamawa", "Akwa Ibom", "Anambra", "Bauchi", "Bayelsa", "Benue", "Borno",
                 "Cross River", "Delta", "Ebonyi", "Edo", "Ekiti", "Enugu", "FCT", "Gombe",
                 "Imo", "Jigawa", "Kaduna", "Kano", "Katsina", "Kebbi", "Kogi", "Kwara", "Lagos",
                 "Nasarawa", "Niger", "Ogun", "Ondo", "Osun", "Oyo", "Plateau", "Rivers",
                 "Sokoto", "Taraba", "Yobe", "Zamfara"]
      @emergency_organizations = ["Police", "Road Safety", "Fire Service"]
    end
  end

  def create
    logger.debug "Sign-up params: #{params.inspect}"
    build_resource(sign_up_params)

    # Build and save organization first
    organization_params = {
      name: params[:organization_name],
      address: params[:organization_address],
      phone: params[:organization_phone],
      organization_type: params[:organization_type] || "hospital",
      state: params[:state].presence,
      emergency_organization_type: params[:emergency_organization_type].presence
    }
    logger.debug "Organization params: #{organization_params.inspect}" # Add this for debugging
    organization = Organization.new(organization_params)

    ActiveRecord::Base.transaction do
      if organization.save
        logger.debug "Organization saved: #{organization.inspect}" # Debug after save
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
          raise ActiveRecord::Rollback
        end
      else
        logger.debug "Failed to save organization: #{organization.errors.full_messages}"
        raise ActiveRecord::Rollback
      end
    end

    unless performed?
      clean_up_passwords resource
      set_minimum_password_length
      @states = ["Abia", "Adamawa", "Akwa Ibom", "Anambra", "Bauchi", "Bayelsa", "Benue", "Borno",
                 "Cross River", "Delta", "Ebonyi", "Edo", "Ekiti", "Enugu", "FCT", "Gombe",
                 "Imo", "Jigawa", "Kaduna", "Kano", "Katsina", "Kebbi", "Kogi", "Kwara", "Lagos",
                 "Nasarawa", "Niger", "Ogun", "Ondo", "Osun", "Oyo", "Plateau", "Rivers",
                 "Sokoto", "Taraba", "Yobe", "Zamfara"]
      @emergency_organizations = ["Police", "Road Safety", "Fire Service"]
      flash[:alert] = (resource.errors.full_messages + organization.errors.full_messages).join(", ")
      render :new, status: :unprocessable_entity
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