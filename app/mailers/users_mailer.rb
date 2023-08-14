class UsersMailer < ApplicationMailer

    def activate_account(user)
        @user = user
        mail(to: @user.email, subject:"activate your account")
    end

    def reset_password(user)
        @user = user
        mail(to: @user.email, subject:"reset your password")
    end
end
