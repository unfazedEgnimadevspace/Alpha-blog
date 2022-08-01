class User < ApplicationRecord
    before_save { email.downcase! }
    has_many :articles
    validates :username, presence: true, length: { minimum: 3, maximum: 25}, uniqueness: { case_sensitive: false}
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 105}, uniqueness: true, format: { with: VALID_EMAIL_REGEX}, uniqueness: { case_sensitive: false}

    has_secure_password
    validates :password_digest, presence: true, length: { minimum: 6}
end