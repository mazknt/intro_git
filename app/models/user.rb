class User < ApplicationRecord
    validates :name, presence: true,  length: { maximum: 50 }
    validates :email, presence: true, length: { maximum: 250 },
            format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, uniqueness: true
    validates :password, presence: true, length: { minimum:6}
            before_save :email_downcase
    has_secure_password
    attr_accessor :remember_token

    def remember
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
        
    end

    def forget
        self.remember_token = nil
        update_attribute(:remember_digest, nil)
        
    end

    def authenticated?(token)
        return false if remember_digest.nil?
        BCrypt::Password.new(remember_digest).is_password?(token)
    end

    def User.new_token
        SecureRandom.urlsafe_base64(10)
    end

    def User.digest(token)
        BCrypt::Password.create(token)
    end

    

    private 
        def email_downcase
            self.email = email.downcase
        end
end
