module Swap
    include ActiveSupport::Concern
    
    def swap!(*)
        @chat_config.language_source, @chat_config.language_translation = @chat_config.language_translation, @chat_config.language_source
        @chat_config.save

        language_from = "#{t("languages.#{@chat_config.language_source}")} #{WORDREFERENCE_LANGUAGES[@chat_config.language_source.to_sym][:icon]}"
        language_to = "#{t("languages.#{@chat_config.language_translation}")} #{WORDREFERENCE_LANGUAGES[@chat_config.language_translation.to_sym][:icon]}"

        respond_with :message, 
                    text: I18n.t('command.language.translate_from_to',  {
                                                                            language_from: language_from, 
                                                                            language_to: language_to 
                                                                        }), 
                    parse_mode: 'Markdown'
        
    end
    
end
  