module Help
    include ActiveSupport::Concern
    
    def help!(*)
        language_from = "#{WORDREFERENCE_LANGUAGES[@chat_config.language_source.to_sym][:title]} #{WORDREFERENCE_LANGUAGES[@chat_config.language_source.to_sym][:icon]}"
        language_to = "#{WORDREFERENCE_LANGUAGES[@chat_config.language_translation.to_sym][:title]} #{WORDREFERENCE_LANGUAGES[@chat_config.language_translation.to_sym][:icon]}"
        text = I18n.t('app.messages.help', { language_from: language_from, language_to: language_to, website_source: @chat_config.website_source})        
        respond_with :message, text: text, parse_mode: 'Markdown'
    end
    
end
  