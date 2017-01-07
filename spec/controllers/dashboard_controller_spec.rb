require 'rails_helper'

RSpec.describe DashboardController, type: :controller do

  describe "GET #index" do
    it "redirects to root if not signed in" do
      get :index
      expect(response.status).to eq(302)
      expect(response).to redirect_to new_user_session_path
    end

    it "gets a list of the logged in users content" do
      user = User.create(valid_user)
      content = user.likeable_contents.create(valid_content)

      sign_in user

      get :index

      expect(assigns(:content)).to eq([content])
    end

    it "gets a list of only the logged in users content" do
      user = User.create(valid_user)
      user2 = User.create(valid_user(email: 'other@ilikeit.io'))

      sign_in user

      content1 = user.likeable_contents.create(valid_content)
      content2 = user2.likeable_contents.create(valid_content)

      get :index

      expect(assigns(:content)).to eq([content1])
      expect(assigns(:content).size).to eq(1)
      expect(assigns(:content).first).to_not eq(content2)
    end
  end

  private

  def valid_user(attr = {})
    {
      first_name: 'John',
      last_name: 'Cena',
      email: 'john.cena@ilikeit.co.za',
      password: 'ucantseeme!'
    }.merge(attr)
  end

  def valid_content(attr = {})
    {
      title: 'My Content'
    }
  end
end
