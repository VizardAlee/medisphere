class HomeController < ApplicationController
  before_action :authenticate_user!, except: [ :index ]

  def index
    # This is the default page for unauthenticated users
  end
end
