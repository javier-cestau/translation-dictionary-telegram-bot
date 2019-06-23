class Scraper

    include Translation

    def initialize(service)
      @service = service
    end

    def make_request(chat_config, message_text)
        url = "https://www.wordreference.com/#{chat_config.language_source}#{chat_config.language_translation}/#{message_text}"

        # I could use APIFY or ScaperAPI service when it's needed
        if @service == 'apify'

            RestClient.post(ENV['APIFY_URL'], 
                {
                    "startUrls": [
                        {
                        "url": url,
                        "method": "GET"
                        }
                    ],
                    "pseudoUrls": [
                        {
                        "purl": url,
                        "method": "GET"
                        }
                    ],
                    "customData": {
                        "chat_id": chat_config.telegram_chat_id,
                        "message_text": message_text
                    }
                }.to_json,
                { 
                    content_type: :json, 
                    accept: :json
                })   
            text = I18n.t('service.apify.translating')
        else

            key_cache = "#{message_text.parameterize}:#{chat_config.language_source}#{chat_config.language_translation}"

            if Rails.cache.exist?("#{key_cache}:swap")
                key_cache = "#{key_cache}:swap"
            elsif Rails.cache.exist?("#{message_text.parameterize}:#{chat_config.language_translation}#{chat_config.language_source}:swap")
                key_cache = "#{message_text.parameterize}:#{chat_config.language_translation}#{chat_config.language_source}:swap"
            end

            if Rails.cache.exist?(key_cache)
                puts key_cache
                result = Rails.cache.fetch(key_cache)
            else
                url_scraper_api = "http://api.scraperapi.com?api_key=#{ENV['SCARPER_API_KEY']}&url=#{URI.encode(url)}"
                r = RHandler.new
                r.source('wordreference_scraper.R', Rails.env.production? ? url_scraper_api : URI.encode(url) ) # Avoid spend monthly requests on scaperAPI service on development
                result = Translation::Message.generate(r, chat_config, message_text, key_cache)
                r.quit
            end

            splited_text = result.split("***")
            
            if splited_text.length != 1
                language_source = splited_text[0]
                language_translation = splited_text[1]
                
                language_from = WORDREFERENCE_LANGUAGES[language_source.to_sym][:icon]
                language_to = "#{ I18n.t("languages.#{language_translation}")} #{WORDREFERENCE_LANGUAGES[language_translation.to_sym][:icon]}"
                text = "#{language_from} *#{message_text}* #{I18n.t('app.messages.to')} #{language_to}: \n " + splited_text[2]
            else
                text = result
            end
        end

        return text
    end

end