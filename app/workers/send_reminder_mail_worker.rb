class SendReminderMailWorker
  include Sidekiq::Worker

  def perform(email)
    UserMailer.generate_reminder_mail(email).deliver
    return self.jid
  end
end

