class User < ApplicationRecord
    attr_accessor :remember_token, :activation_token, :reset_token
    before_save :downcase_email
    before_create :create_activation_digest
    has_many :articles
    has_many :active_relationships, class_name: "Relationship",
                                    foreign_key: "follower_id",
                                    dependent: :destroy

    has_many :passive_relationships, class_name: "Relationship",
                                     foreign_key: "followed_id",
                                     dependent: :destroy

    has_many :following, through: :active_relationships, source: :followed
    has_many :followers, through: :passive_relationships, source: :follower

    validates :username, presence: true, length: { minimum: 3, maximum: 25}, uniqueness: { case_sensitive: false}
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 105}, format: { with: VALID_EMAIL_REGEX}, uniqueness: { case_sensitive: false}

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
        self.remember_token = User.new_token
        update_attribute(:remeber_digest, User.digest(remember_token))
    end
    def authenticated?(attribute, token)
        digest = send("#{attribute}_digest")
        return false if digest.nil?
        BCrypt::Password.new(digest).is_password?(token)
     end
        
    def forget
        update_attribute(:remeber_digest, nil)
    end
    def activate
        update_attribute(:activated, true)
        update_attribute(:activated_at, Time.zone.now)
    end
        # Sends activation email.
    def send_activation_email
        UserMailer.account_activation(self).deliver_now
    end
    def create_reset_digest
        self.reset_token = User.new_token
        update_attribute(:reset_digest, User.digest(reset_token))
        update_attribute(:reset_sent_at, Time.zone.now)
    end
    def send_password_reset_email
        UserMailer.password_reset(self).deliver_now
    end
    def follow(other_user)
        following << other_user
    end
        # Unfollows a user.
     def unfollow(other_user)
        following.delete(other_user)
     end
        # Returns true if the current user is following the other user.
     def following?(other_user)
        following.include?(other_user)
     end
     def password_reset_expired?
        reset_sent_at < 2.hours.ago
     end
        
    private
  
        def downcase_email
             email.downcase! 
        end
        def create_activation_digest
            self.activation_token = User.new_token
            self.activation_digest = User.digest(activation_token)

        end

end