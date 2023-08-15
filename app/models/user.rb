class User < ApplicationRecord
    validates :name, presence: true,  length: { maximum: 50 }
    validates :email, presence: true, length: { maximum: 250 },
            format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, uniqueness: true
    validates :password, presence: true, length: { minimum:6}, allow_nil: true
            before_save :email_downcase
    has_secure_password
    attr_accessor :remember_token, :activation_token, :reset_token
    before_save :activate
    has_many :microposts, dependent: :destroy

    def remember
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
        
    end

    def forget
        self.remember_token = nil
        update_attribute(:remember_digest, nil)
        
    end

    def authenticated?(column, token)
        return false if self.send("#{column}_digest").nil?
        BCrypt::Password.new(self.send("#{column}_digest")).is_password?(token)
    end

    def User.new_token
        SecureRandom.urlsafe_base64(10)
    end

    def User.digest(token)
        BCrypt::Password.create(token)
    end

    def reset_password
        self.reset_token = User.new_token
        #self.reset_digest = User.digest(reset_token)
        update_attribute(:reset_digest, User.digest(reset_token))
    end

    

    private 
        def email_downcase
            self.email = email.downcase
        end

        def activate
            self.activation_token = User.new_token
            self.activation_digest = User.digest(activation_token)
        end
end
