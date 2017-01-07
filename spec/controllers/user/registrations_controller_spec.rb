require 'spec_helper'
require 'rails_helper'

RSpec.describe User::RegistrationsController, :type => :controller do
  before(:each) do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'GET #new' do
    it 'render successfully' do
      get :new
      expect(response.status).to eq(200)
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