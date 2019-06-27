module Report
    include ActiveSupport::Concern
    
    def report!(*)
        save_context :severity
        respond_with :message, text: "Please tell us, what problem do you want to report?", parse_mode: 'Markdown'               
        end
        
    def severity(message_problem, *)
        session[:message_problem] = message_problem
        keyboard = []
        5.times.each do |times|
            urgent = [
                'Not Urgent',
                'Low Priority',
                'Medium Priority',
                'High Priority',
                'Critical'
            ] 
            keyboard.push(
                {
                    text: "🚨"*(times+1) + " #{times+1} (#{urgent[times]})",
                    callback_data: "send_email:#{times}"
                }
            )
        end
        keyboard.push(
            {
                text: "❌ Cancel Report",
                callback_data: "send_email:cancel"
            }
        )
        save_context :send_message
        respond_with :message, text: "How urgent do you think is the problem?", parse_mode: 'Markdown', reply_markup: {
            inline_keyboard: keyboard.each_slice(1).to_a
        }
    end

    def send_email_callback_query(severity_response)
        return respond_with :message, text: '👌 Report Canceled' if severity_response == 'cancel'
        
        ReportMailer.report_email(severity_response, session[:message_problem]).deliver_later
        respond_with :message, text: 'Thank you for reporting'
    end

end
  
  