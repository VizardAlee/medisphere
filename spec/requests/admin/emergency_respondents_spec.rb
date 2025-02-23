require 'rails_helper'

RSpec.describe "Admin::EmergencyRespondents", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/admin/emergency_respondents/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/admin/emergency_respondents/update"
      expect(response).to have_http_status(:success)
    end
  end

end
