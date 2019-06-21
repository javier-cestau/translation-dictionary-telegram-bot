module Config
    include ActiveSupport::Concern
    
    def config!(*)

        language_from = "#{t("languages.#{@chat_config.language_source}")} #{WORDREFERENCE_LANGUAGES[@chat_config.language_source.to_sym][:icon]}"
        language_to = "#{t("languages.#{@chat_config.language_translation}")} #{WORDREFERENCE_LANGUAGES[@chat_config.language_translation.to_sym][:icon]}"
        respond_with :message, 
                    text: I18n.t('command.config',  {
                                                                            language_from: language_from, 
                                                                            language_to: language_to 
                                                                        }), 
                    parse_mode: 'Markdown'
        
    end
    
end
  