class ApplicationMailer < ActionMailer::Base
  default to: ENV['TO_EMAIL']
  layout 'mailer'
end
