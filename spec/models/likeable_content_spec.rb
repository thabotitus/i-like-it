require 'rails_helper'

describe LikeableContent, type: :model do
  it 'has a title' do
    content = LikeableContent.new(title: '')
    expect(content.valid?).to eq(false)
  end

  it 'does not need a description' do
    user = User.create(valid_user)
    content = LikeableContent.new(title: 'card', description: '', identifier: "string", user: user)
    expect(content.valid?).to eq(true)
  end

  context '#identifier' do
    it 'has a unique identifier' do
      user = User.create(valid_user)
      content = LikeableContent.create(title: 'card', user: user)
      expect(content.valid?).to eq(true)
    end

    it 'has a string value' do
      stub_unique_identifier
      user = User.create(valid_user)
      content = LikeableContent.create(title: 'card', user: user)
      expect(content.identifier).to eq('unique-indentifier')
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
