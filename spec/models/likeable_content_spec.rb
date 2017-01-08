require 'rails_helper'

describe LikeableContent, type: :model do
  it 'has a title' do
    content = LikeableContent.new(title: '')
    expect(content.valid?).to eq(false)
  end

  it 'does not need a description' do
    user = User.create(valid_user)
    content = user.likeable_contents.create(title: 'card')
    expect(content.valid?).to eq(true)
  end

  context '#identifier' do
    it 'has a unique identifier' do
      user = User.create(valid_user)
      content = user.likeable_contents.create(title: 'card')
      expect(content.valid?).to eq(true)
    end

    it 'has a string value' do
      stub_unique_identifier
      user = User.create(valid_user)
      content = user.likeable_contents.create(title: 'card')
      expect(content.identifier).to eq('unique-indentifier')
    end
  end

  context '#likes' do
    it 'has likes' do
      user = User.create(valid_user)
      content = user.likeable_contents.create(title: 'My Content')
      content.likes.create

      expect(content.likes.count).to eq 1
    end
  end

  private

  def stub_unique_identifier
    allow_any_instance_of(LikeableContent).to receive(:generate_uuid).and_return('unique-indentifier')
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
