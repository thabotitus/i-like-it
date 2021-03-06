require 'rails_helper'

RSpec.describe LikeableContentController, type: :controller do

  describe "GET #new" do
    before(:each) do
      sign_in_valid_user
    end

    it 'renders successfully' do
      get :new
      expect(response.status).to eq 200
    end

    it 'initializes new likeable content object' do
      get :new
      expect(assigns(:content)).to be_a LikeableContent
    end
  end

  describe "GET #show" do
    it 'renders successfully' do
      user = User.create(valid_user)
      content = user.likeable_contents.create(title: 'My content')
      sign_in user

      get :show, params: { id: content._id }

      expect(response.status).to eq 200
    end

    it 'does not show content that does not belong to you' do
      user = User.create(valid_user)
      user2 = User.create(valid_user(email: 'another@ilikeit.io'))

      content = user.likeable_contents.create(title: 'My content')
      content2 = user2.likeable_contents.create(title: 'My content')

      sign_in user

      get :show, params: { id: content2._id }

      expect(response.status).to eq 302
      expect(response).to redirect_to dashboard_index_path
      expect(flash[:error]).to eq 'Page Does Not Exist'
      expect(assigns(:content)).to be_nil
    end
  end

  describe "POST #create" do
    before(:each) do
      sign_in_valid_user
    end

    it 'saves a new likeable content' do
      content = { title: 'My Content' }

      post :create, params: { likeable_content: content }

      expect(LikeableContent.count).to eq 1
      expect(LikeableContent.first.user).to eq @user
    end

    it 'renders the show page after create' do
      content = { title: 'My Content' }

      post :create, params: { likeable_content: content }

      new_content = LikeableContent.first
      expect(response).to redirect_to  likeable_content_path(new_content)
      expect(flash[:success]).to eq 'Content Saved'
    end

    it 'does not redirect if the content wasnt saved' do
      content = { title: nil }

      post :create, params: { likeable_content: content }

      expect(response.status).to eq 200
      expect(flash[:error]).to eq 'Content Not Saved'
    end
  end

  describe "PUT #update" do
    before(:each) do
      sign_in_valid_user
    end

    it 'updates the content' do
      content = @user.likeable_contents.create(title: 'My Content')
      new_attributes = { title: "My New Content Title", description: "An actual description"}

      put :update, params: { id: content.id, likeable_content: new_attributes }

      content.reload
      expect(content.title).to eq 'My New Content Title'
      expect(content.description).to eq 'An actual description'
      expect(flash[:success]).to eq 'Content Updated'
      expect(response).to redirect_to likeable_content_path(content)
    end

    it 'does not update another users content' do
      user2 = User.create(valid_user(email: 'anotherone@ilikeit.io'))
      content = @user.likeable_contents.create(title: 'My Content')
      content2 = user2.likeable_contents.create(title: 'My Other Content')

      new_attributes = { title: "My New Content Title", description: "An actual description"}

      put :update, params: { id: content2.id, likeable_content: new_attributes }
      content2.reload
      expect(content2.title).to eq 'My Other Content'
      expect(response).to redirect_to dashboard_index_path
      expect(flash[:error]).to eq 'Content Does Not Exist'
    end

    it 'does not redirect if content is not saved' do
      content = @user.likeable_contents.create(title: 'My Content')
      new_attributes = { title: nil }

      put :update, params: { id: content.id, likeable_content: new_attributes }

      expect(response.status).to eq 200
      expect(flash[:error]).to eq 'Content Not Updated'
    end
  end

  private

  def sign_in_valid_user
    @user = User.create(valid_user)
    sign_in @user
  end

  def valid_user(attr = {})
    {
      first_name: 'John',
      last_name: 'Cena',
      email: 'john.cena@ilikeit.co.za',
      password: 'ucantseeme!'
    }.merge(attr)
  end
end
