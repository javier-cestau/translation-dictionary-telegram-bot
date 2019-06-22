class TelegramWebhookController < ApplicationController
    
    # This controller will be used only by Apify service
    include Translation

    def succeeded
        body_apify = JSON.parse(RestClient.get(ENV['APIFY_URL_DATASET'].sub('datasetId', params['resource'])).body)[0]        
        @chat_config = Chat.find_or_create_by(telegram_chat_id: body_apify['chat_id'])
        
        message_text = body_apify['message_text']
        format_message_text = I18n.transliterate(message_text.parameterize)   
        File.open("#{Rails.root}/public/translations/#{format_message_text}.html", 'w') {|f| f.write(body_apify['html']) }
     
        r = RHandler.new

        r.source('wordreference_scraper.R', "#{Rails.root}/public/translations/#{format_message_text}.html")
        r.quit
        check_language_translated(body_apify['html'])
        text = Translation::Message.generate(r, @chat_config, message_text)
        
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