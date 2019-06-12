module Help
    include ActiveSupport::Concern
    
    def help!(*)
        respond_with :message, text: "You have requested for help", parse_mode: 'Markdown'
    end
    
end
  