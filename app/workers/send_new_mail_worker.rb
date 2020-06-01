class SendNewMailWorker
  include Sidekiq::Worker

  def perform(email)
    UserMailer.generate_new_mail(email).deliver
  end
end
