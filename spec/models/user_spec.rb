require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a first name' do
    user = User.new(valid_user(first_name: ''))
    expect(user.valid?).to eq(false)
  end

  it 'has a last name' do
    user = User.new(valid_user(last_name: ''))
    expect(user.valid?).to eq(false)
  end

  it 'has an email address' do
    user = User.new(valid_user(email: ''))
    expect(user.valid?).to eq(false)
  end

  it 'has a password' do
    user = User.new(valid_user(password: ''))
    expect(user.valid?).to eq(false)
  end

  it 'has an api token' do
    allow(Digest::SHA256).to receive(:hexdigest).and_return('unique-token')
    user = User.create(valid_user)
    expect(user.api_token).to eq('unique-token')
  end

  it 'can create likeable content' do
    user = User.create(valid_user)
    content = user.likeable_contents.create
    expect(user.likeable_contents.first).to eq(content)
  end

  it 'can create likeable content that only belongs to it' do
    user = User.create(valid_user)
    user2 = User.create(valid_user)
    content = user.likeable_contents.create

    expect(user.likeable_contents.size).to eq(1)
    expect(user2.likeable_contents.size).to eq(0)
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
