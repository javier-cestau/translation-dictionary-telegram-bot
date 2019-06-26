module Language
    include ActiveSupport::Concern

    def language!
        options = []
        WORDREFERENCE_LANGUAGES.each do |code, language_info|
            options.push({
                text: "#{language_info[:icon]} #{t("languages.#{code}")} (#{code})",
                callback_data: "source:#{code}"
            })
        end
        text = t('command.language.initial_text')

        respond_with :message, text: text, parse_mode: 'Markdown', reply_markup: {
            inline_keyboard: options.each_slice(2).to_a
          }
    end     

    def source_callback_query(language_source_code)

        if language_source_code.nil?
            return respond_with :message, text: t('command.language.error'), parse_mode: 'Markdown'
        end       
                                                    
        options = []
        WORDREFERENCE_LANGUAGES[language_source_code.to_sym][:translate_to].each do |code|
            options.push({
                text: "#{WORDREFERENCE_LANGUAGES[code.to_sym][:icon]} #{t("languages.#{code}")} (#{code})",
                callback_data: "translation:#{code}"
            })

        end

        language_source_text = "#{WORDREFERENCE_LANGUAGES[language_source_code.to_sym][:icon]} #{t("languages.#{language_source_code}")}"
        
        text = t('command.language.second_text', { language_source: language_source_text }) 
     
        session[:language_source] = language_source_code
        respond_with :message, text: text, parse_mode: 'Markdown', reply_markup: {
            inline_keyboard: options.each_slice(2).to_a
        }
    end
    
    def translation_callback_query(translation_code)
        return if session[:language_source].nil?

        if translation_code.nil?
            return respond_with :message, text: t('command.language.error'), parse_mode: 'Markdown'
        end       

        language_from = "#{t("languages.#{session[:language_source]}")} #{WORDREFERENCE_LANGUAGES[session[:language_source].to_sym][:icon]}"
        language_to = "#{t("languages.#{translation_code}")} #{WORDREFERENCE_LANGUAGES[translation_code.to_sym][:icon]}"
        WORDREFERENCE_LANGUAGES[session[:language_source].to_sym][:translate_to].each do |code|
        
            #
            # This means that we can translate from the select languages 
            # which the user has selected
            #
            
            if code == translation_code
                @chat_config.update(language_translation: translation_code, language_source: session[:language_source] )
        
                session[:language_source] = nil
                # SUCCESS
                respond_with :message, 
                                    text: I18n.t('command.language.translate_from_to',  {
                                                                    language_from: language_from, 
                                                                    language_to: language_to 
                                                                }), 
                                    parse_mode: 'Markdown'
                return
            end
        end

        # ERROR
        respond_with :message, 
                text: I18n.t('command.language.error_match_languages',  {
                                                language_from: language_from, 
                                                language_to: language_to 
                                            }), 
                parse_mode: 'Markdown'
    end

end
  