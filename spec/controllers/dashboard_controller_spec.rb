require 'rails_helper'

RSpec.describe DashboardController, type: :controller do

  describe "GET #index" do
    it "redirects to root if not signed in" do
      get :index
      expect(response.status).to eq(302)
      expect(response).to redirect_to new_user_session_path
    end
  end

end
