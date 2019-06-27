class ReportMailer < ApplicationMailer

    def report_email(severity, message)
        @message = message
        mail from: 'dictionary-telegram-bot.com', subject: "Report Level #{severity}"
    end  
end
  