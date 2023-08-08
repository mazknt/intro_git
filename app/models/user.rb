class User < ApplicationRecord
    validates :name, presence: true,  length: { maximum: 50 }
    validates :email, presence: true, length: { maximum: 250 },
            format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, uniqueness: true
    validates :password, presence: true, length: { minimum:6}
            before_save :email_downcase
    has_secure_password

    private 
        def email_downcase
            self.email = email.downcase
        end
end
