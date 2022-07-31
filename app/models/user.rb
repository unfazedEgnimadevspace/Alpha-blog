class User < ApplicationRecord
    validates :username, presence: true, length: { minimum: 6, maximum: 50}
    validates :email, presence: true, length: { maximum: 250}
end