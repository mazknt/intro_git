class ActivateAccountsMailer < ApplicationMailer

    def activate_account(user)
        @user = user
        mail(to: @user.email, subject:"activate your account")
    end
    
end
