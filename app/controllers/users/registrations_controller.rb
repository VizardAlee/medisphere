class Users::RegistrationsController < Devise::RegistrationsController
  def new
    super
  end

  def create
    @organization = Organization.new(
      name: params[:organization_name],
      address: params[:organization_address],
      phone: params[:organization_phone]
    )
  
    if @organization.save
      user = User.new(sign_up_params)
      user.role = :admin  # Explicitly set the role
      user.organization_id = @organization.id
  
      Rails.logger.debug "User role before saving: #{user.role}"
      if user.save
        Rails.logger.debug "User role after saving: #{user.role}"

        sign_up(:user, user)
        redirect_to dashboard_path, notice: "Account successfully created!"
      else
        flash[:alert] = "Error creating user."
        redirect_to new_user_registration_path
      end
    else
      flash[:alert] = "Error creating organization."
      redirect_to new_user_registration_path
    end
  end
  

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :role)
  end
end
