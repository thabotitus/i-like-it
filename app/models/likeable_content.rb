class LikeableContent
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :description, type: String
  field :identifier, type: String

  before_create :create_unique_identifier

  belongs_to :user
  embeds_many :likes

  validates :title, presence: true

  private

  def create_unique_identifier
    self.identifier = generate_uuid
  end

  def generate_uuid
    SecureRandom.uuid
  end

  def self.find_by_identifier(unique_identifier)
    where(identifier: unique_identifier).first
  end
end