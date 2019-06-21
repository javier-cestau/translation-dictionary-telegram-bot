module Language
    include ActiveSupport::Concern

    def language!
        options = []
        WORDREFERENCE_LANGUAGES.each do |code, language_info|
            options.push("#{language_info[:icon]} #{t("languages.#{code}")}: #{code}")
        end
        text = t('command.language.initial_text', { options: options.join("\n")})

        save_context :language_source
        respond_with :message, text: text, parse_mode: 'Markdown'
    end
     
    def language_source(language_source= '',*)
        language_source_code = language_source.length != 2 ? convert_word_language_to_code(language_source.downcase) 
                                                           : language_source.downcase

        if language_source_code.nil?
            return respond_with :message, text: t('command.language.error'), parse_mode: 'Markdown'
        end       
                                                    
        options = []
        WORDREFERENCE_LANGUAGES[language_source_code.to_sym][:translate_to].each do |code|
            options.push("#{WORDREFERENCE_LANGUAGES[code.to_sym][:icon]} #{t("languages.#{code}")}: #{code}")
        end

        language_source_text = "#{WORDREFERENCE_LANGUAGES[language_source_code.to_sym][:icon]} #{t("languages.#{language_source_code}")}"
        
        text = t('command.language.second_text', { options: options.join("\n"), language_source: language_source_text }) 
     
        session[:language_source] = language_source_code
        save_context :language_translation
        respond_with :message, text: text, parse_mode: 'Markdown'
    end
 
 
    def language_translation(translation= '',*)
        translation_code = translation.length != 2 ? convert_word_language_to_code(translation.downcase) 
                                                   : translation.downcase
        if translation_code.nil?
            return respond_with :message, text: t('command.language.error'), parse_mode: 'Markdown'
        end       
                                        
        @chat_config.update(language_translation: translation_code, language_source: session[:language_source] )

        language_from = "#{t("languages.#{@chat_config.language_source}")} #{WORDREFERENCE_LANGUAGES[@chat_config.language_source.to_sym][:icon]}"
        language_to = "#{t("languages.#{@chat_config.language_translation}")} #{WORDREFERENCE_LANGUAGES[@chat_config.language_translation.to_sym][:icon]}"
        respond_with :message, 
                    text: I18n.t('command.language.translate_from_to',  {
                                                                            language_from: language_from, 
                                                                            language_to: language_to 
                                                                        }), 
                    parse_mode: 'Markdown'
    end
    
    private 

    def convert_word_language_to_code(language_word)
        I18n.available_locales.each do |locale|
            I18n.backend.send(:translations)[locale][:languages].each do |list_locale|
                if I18n.transliterate(language_word).downcase == I18n.transliterate(t("languages.#{list_locale[0]}", :locale => locale)).downcase
                    return list_locale[0]
                end
            end
        end
        return nil
    end
    
end
  