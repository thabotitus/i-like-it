class LikeableContent
  include Mongoid::Document

  field :title, type: String
  field :description, type: String
  field :identifier, type: String

  before_create :create_unique_identifier

  validates :title, presence: true

  private

  def create_unique_identifier
    self.identifier = generate_uuid
  end

  def generate_uuid
    SecureRandom.uuid
  end
end