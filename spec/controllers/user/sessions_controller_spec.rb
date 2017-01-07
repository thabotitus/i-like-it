require 'spec_helper'
require 'rails_helper'

RSpec.describe User::SessionsController, :type => :controller do
  before(:each) do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end
  describe 'GET #new' do
    it 'render successfully' do
      get :new
      expect(response.status).to eq(200)
    end

    it 'signs in a user' do
      user = User.create(valid_user)
      sign_in user
      get :new
      expect(controller.user_signed_in?).to eq(true)
    end

    it 'signs out a user' do
      user = User.create(valid_user)
      sign_in user
      get :new
      sign_out user
      expect(controller.user_signed_in?).to eq(false)
    end

    it 'redirects to dashboard after sign in' do
      user = User.create(valid_user)
      sign_in user
      get :new

      expect(response).to redirect_to dashboard_index_path
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
end