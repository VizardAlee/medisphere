require 'rails_helper'

RSpec.describe "Staffs", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/staffs/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/staffs/create"
      expect(response).to have_http_status(:success)
    end
  end

end
