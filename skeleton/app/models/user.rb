class User < ApplicationRecord
  validates :session_token, :username, presence: true, uniqueness: true
  validates :password_digest, presence: true 
  validates :password, length: {minimum: 6}, allow_nil: true

  attr_reader :password
  after_initialize :ensure_session_token

  has_many :cats

  def new
    @user = User.new
  end

  def self.find_by_credentials(username, password)
    @user = User.find_by(username: username)

    return nil unless @user

    if @user.is_password?(password)
      return @user
    end
    nil

  end

  def ensure_session_token
    self.session_token ||= SecureRandom::urlsafe_base64
  end

  def reset_session_token!
    self.session_token = SecureRandom::urlsafe_base64
    self.save!
    self.session_token
  end

  def password=(password)
    self.password_digest = BCrypt::Password.create(password) ## creating random hash
    @password = password
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end




end
