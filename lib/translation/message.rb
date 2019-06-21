module Translation
    class Message
        def self.generate(r, chat_config, message_text)
            from_word_unformatted =  r.get_var('from_word')
            to_word_unformatted =  r.get_var('to_word')
            
            from_word_formatted = from_word_unformatted.class == Array ?  from_word_unformatted.uniq.map(&:strip).join(', ') : from_word_unformatted
            to_word_formatted = to_word_unformatted.class == Array ?  to_word_unformatted.uniq.map(&:strip).join(', ') : to_word_unformatted
            
            language_from = WORDREFERENCE_LANGUAGES[chat_config.language_source.to_sym][:icon]
            language_to = "#{ I18n.t("languages.#{chat_config.language_translation}")} #{WORDREFERENCE_LANGUAGES[chat_config.language_translation.to_sym][:icon]}"
            text = "#{language_from} *#{message_text}* to #{language_to}: \n" \
                "- #{from_word_formatted}: #{to_word_formatted} \n" \
                "\nTranslation made from: wordreference.com"
            return text
        end
    end
end
