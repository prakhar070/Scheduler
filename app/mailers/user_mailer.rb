class UserMailer < ApplicationMailer
    def generate_reminder_mail(email)
        mail(:to => email, :subject => "Reminder for Interview")
    end

    def generate_new_mail(email)
        mail(:to => email, :subject => "A new Interview scheduled")
    end
end
