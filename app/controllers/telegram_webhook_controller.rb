class TelegramWebhookController < ApplicationController

    def succeeded
        body = JSON.parse(RestClient.get(ENV['APIFY_URL_DATASET'].sub('datasetId', params['resource'])).body)[0]        
        @chat_config = Chat.find_or_create_by(telegram_chat_id: body['chat_id'])
        message_text = body['message_text']
        
        r = RHandler.new
        r.source(
                'translate.R', 
                body['html'],
                message_text
        ) 
        
        check_language_translated(body['html'])
        
        from_word_unformatted =  r.get_var('from_word')
        to_word_unformatted =  r.get_var('to_word')
        
        from_word_formatted = from_word_unformatted.class == Array ?  from_word_unformatted.uniq.map(&:strip).join(', ') : from_word_unformatted
        to_word_formatted = to_word_unformatted.class == Array ?  to_word_unformatted.uniq.map(&:strip).join(', ') : to_word_unformatted

        language_from = WORDREFERENCE_LANGUAGES[@chat_config.language_source.to_sym][:icon]
        language_to = "#{ I18n.t("languages.#{@chat_config.language_translation}")} #{WORDREFERENCE_LANGUAGES[@chat_config.language_translation.to_sym][:icon]}"
        text = "#{language_from} *#{message_text}* to #{language_to}: \n" \
               "- #{from_word_formatted}: #{to_word_formatted} \n" \
               "\nTranslation made from: wordreference.com"
        
        
        Telegram.bot.send_message(chat_id: @chat_config.telegram_chat_id, text: text, parse_mode: 'Markdown')
        render json: { status: '200' }
    end

    private

    def check_language_translated(html)
        doc = Nokogiri::HTML(html)
        languages_used = doc.search('#nav a:first-child')[0].attributes['href'].value
        
        puts languages_used

        if languages_used != "/#{@chat_config.language_source}#{@chat_config.language_translation}/"
            # Swap variables value
            @chat_config.language_source, @chat_config.language_translation = @chat_config.language_translation, @chat_config.language_source
        end
    end

end