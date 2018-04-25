class ApplicationMailer < ActionMailer::Base
  default from: 'info@trelloclone.com'
  layout 'mailer'

  def send_forgot_password(user)
    @user = user
    mail to: user.email, from: 'info@trelloclone.com', subject: 'TrelloClone password reset'
  end
end
