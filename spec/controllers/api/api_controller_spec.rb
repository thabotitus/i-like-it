require 'rails_helper'

RSpec.describe Api::ApiController, type: :controller do

  describe "GET #total_likes" do
    it 'validates the api token' do
      user = User.create(valid_user)
      content = user.likeable_contents.create(valid_content)
      content.likes.create

      get :total_likes, params: {identifier: content.identifier, api_token: user.api_token}

      payload = JSON.parse response.body
      expect(payload['total_likes']).to eq 1
    end

    it 'returns 404 status if token is invalid' do
      user = User.create(valid_user)
      content = user.likeable_contents.create(valid_content)

      get :total_likes, params: {identifier: content.identifier, api_token: 'invalid-token'}

      payload = JSON.parse response.body
      expect(response.status).to eq 404
      expect(payload['error']).to eq 'Invalid Request Data'
    end

    it 'returns 404 status user is invalid' do
      user = User.create(valid_user)
      content = user.likeable_contents.create(valid_content)

      get :total_likes, params: {identifier: 'foo', api_token: user.api_token}

      payload = JSON.parse response.body
      expect(response.status).to eq 404
      expect(payload['error']).to eq 'Invalid Request Data'
    end
  end

  describe "POST #create_like" do
    it 'validates the api token' do
      user = User.create(valid_user)
      content = user.likeable_contents.create(valid_content)
      current_count = content.likes.count

      get :create_like, params: {identifier: content.identifier, api_token: user.api_token}

      payload = JSON.parse response.body
      expect(payload['total_likes']).to eq current_count + 1
    end

    it 'returns 404 status if token is invalid' do
      user = User.create(valid_user)
      content = user.likeable_contents.create(valid_content)

      get :create_like, params: {identifier: content.identifier, api_token: 'invalid-token'}

      payload = JSON.parse response.body
      expect(response.status).to eq 404
      expect(payload['error']).to eq 'Invalid Request Data'
    end

    it 'returns 404 status user is invalid' do
      user = User.create(valid_user)
      content = user.likeable_contents.create(valid_content)

      get :create_like, params: {identifier: 'foo', api_token: user.api_token}

      payload = JSON.parse response.body
      expect(response.status).to eq 404
      expect(payload['error']).to eq 'Invalid Request Data'
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
