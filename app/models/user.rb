class User
  include Mongoid::Document
  include Mongoid::Timestamps
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_create :generate_access_token

  ## Database authenticatable
  field :email,                       type: String, default: ""
  field :encrypted_password,          type: String, default: ""

  ## Recoverable
  field :reset_password_token,        type: String
  field :reset_password_sent_at,      type: Time

  ## Rememberable
  field :remember_created_at,         type: Time

  ## Trackable
  field :sign_in_count,               type: Integer, default: 0
  field :current_sign_in_at,          type: Time
  field :last_sign_in_at,             type: Time
  field :current_sign_in_ip,          type: String
  field :last_sign_in_ip,             type: String

  ## Confirmable
  field :confirmation_token,          type: String
  field :confirmed_at,                type: Time
  field :confirmation_sent_at,        type: Time
  field :unconfirmed_email,           type: String # Only if using reconfirmable

  ## Lockable
  field :failed_attempts,             type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  field :unlock_token,                type: String # Only if unlock strategy is :email or :both
  field :locked_at,                   type: Time

  ## General
  field :first_name,                  type: String
  field :last_name,                   type: String
  field :api_token,                   type: String

  has_many :likeable_contents

  validates :first_name, presence: true
  validates :last_name, presence: true


  def self.find_by_api_token(token)
    where(api_token: token).first
  end

  private

  def generate_access_token
    self.api_token = Digest::SHA256.hexdigest(Time.now.to_s)
  end
end
