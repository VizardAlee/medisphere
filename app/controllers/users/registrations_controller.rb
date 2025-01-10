class Users::RegistrationsController < Devise::RegistrationsController
  def create
    ActiveRecord::Base.transaction do
      # Create the organization with additional parameters
      organization = Organization.new(
        name: params[:organization_name],
        address: params[:organization_address],
        phone: params[:organization_phone]
      )
      unless organization.save
        raise ActiveRecord::RecordInvalid.new(organization)
      end

      # Build the user and associate it with the organization
      build_resource(sign_up_params)
      resource.organization = organization

      # Save the user
      resource.save!
      yield resource if block_given?

      if resource.persisted?
        if resource.active_for_authentication?
          set_flash_message! :notice, :signed_up
          sign_up(resource_name, resource)
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      else
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    flash[:alert] = "Error: #{e.message}"
    logger.error "Error creating organization or user: #{e.record.errors.full_messages.join(", ")}"
    redirect_to new_user_registration_path
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
