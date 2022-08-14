class User < ApplicationRecord
    attr_accessor :remember_token, :activation_token
    before_save :downcase_email
    before_create :create_activation_digest
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

    private
  
        def downcase_email
             email.downcase! 
        end
        def create_activation_digest
            self.activation_token = User.new_token
            self.activation_digest = User.digest(activation_token)

        end

end