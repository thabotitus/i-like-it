require 'rails_helper'

describe LikeableContent do
  it 'has a title' do
    content = LikeableContent.new(title: '')
    expect(content.valid?).to eq(false)
  end

  it 'does not need a description' do
    content = LikeableContent.new(title: 'card', description: '', identifier: "string")
    expect(content.valid?).to eq(true)
  end

  context '#identifier' do
    it 'has a unique identifier' do
      content = LikeableContent.create(title: 'card')
      expect(content.valid?).to eq(true)
    end

    it 'has a string value' do
      stub_unique_identifier
      content = LikeableContent.create(title: 'card')
      expect(content.identifier).to eq('unique-indentifier')
    end
  end

  private

  def stub_unique_identifier
    allow_any_instance_of(LikeableContent).to receive(:generate_uuid).and_return('unique-indentifier')
  end
end
