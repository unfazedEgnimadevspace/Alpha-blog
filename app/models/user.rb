class User < ApplicationRecord
    attr_accessor :remeber_token
    before_save { email.downcase! }
    has_many :articles
    validates :username, presence: true, length: { minimum: 3, maximum: 25}, uniqueness: { case_sensitive: false}
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 105}, uniqueness: true, format: { with: VALID_EMAIL_REGEX}, uniqueness: { case_sensitive: false}

    has_secure_password
    validates :password_digest, presence: true, length: { minimum: 6}
    class << self
        def new_token
            SecureRandom.urlsafe_base64
        end
        def digest(string)
            cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
            BCrypt::Password.create(string, cost: cost)
        end
    end
    def remeber
        self.remeber_token = User.new_token
        update_attribute(:remeber_digest, User.digest(remeber_token))
    end
    def authenticated?(remeber_token)
        return false if remeber_digest.nil?
        BCrypt::Password.new(remeber_digest).is_password?(remeber_token)
    end
    def forget
        update_attribute(:remeber_digest, nil)
    end
end