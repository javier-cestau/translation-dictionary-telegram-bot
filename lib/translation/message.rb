module Translation
    class Message
        def self.generate(r, chat_config, message_text)
            from_word_unformatted =  r.get_var('from_word')
            to_word_unformatted =  r.get_var('to_word')
            language_source =  r.get_var('language_source')
            language_translation =  r.get_var('language_translation')
            from_word_formatted = from_word_unformatted.class == Array ?  from_word_unformatted.uniq.map(&:strip).reject(&:empty?).join(', ') : from_word_unformatted
            to_word_formatted = to_word_unformatted.class == Array ?  to_word_unformatted.uniq.map(&:strip).reject(&:empty?).join(', ') : to_word_unformatted
            
            
            if from_word_formatted.empty? || to_word_formatted.empty?
                return I18n.t('app.messages.error', {message_text: message_text})
            end

            language_from = WORDREFERENCE_LANGUAGES[language_source.to_sym][:icon]
            language_to = "#{ I18n.t("languages.#{language_translation}")} #{WORDREFERENCE_LANGUAGES[language_translation.to_sym][:icon]}"
            text = "#{language_from} *#{message_text}* to #{language_to}: \n" \
                "- #{from_word_formatted}: #{to_word_formatted} \n" \
                "\nTranslation made from: wordreference.com"
            return text
        end
    end
end
