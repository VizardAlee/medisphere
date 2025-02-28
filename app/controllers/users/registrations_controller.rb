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
    # Build and save the organization
    organization = Organization.new(
      name: params[:organization_name],
      address: params[:organization_address],
      phone: params[:organization_phone],
      organization_type: params[:organization_type],
      state: params[:state],
      emergency_organization_type: params[:emergency_organization_type],
      parent_id: 3 # Assuming this links to "Kaduna State Police"
    )

    if organization.save
      # Set user role and state
      user_role = params[:organization_type] == "emergency" ? "emergency_admin" : "admin"
      resource = build_resource(sign_up_params.merge(
        organization_id: organization.id,
        role: user_role,
        state: organization.state # Set user's state to match organization
      ))
      resource.save

      # Redirect after signup
      if resource.persisted?
        sign_up(resource_name, resource)
        redirect_to emergency_respondents_path
      else
        render :new
      end
    else
      render :new
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:name, :email, :phone, :password, :password_confirmation)
  end

  def after_sign_up_path_for(resource)
    if resource.emergency_admin?
      emergency_respondents_path # Direct emergency admins to their specific dashboard
    else
      root_path
    end
  end
end

