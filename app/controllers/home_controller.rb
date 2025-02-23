class HomeController < ApplicationController
  before_action :authenticate_user!, except: [ :index ]

  def index
    @emergency_organizations = Organization.where(organization_type: "emergency")
  end
end
