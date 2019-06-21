class Scraper

    include Translation

    def initialize(service)
      @service = service
    end

    def make_request(chat_config, message_text)
        url = "https://www.wordreference.com/#{chat_config.language_source}#{chat_config.language_translation}/#{message_text}"

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
            url_scraper_api = "http://api.scraperapi.com?api_key=#{ENV['SCARPER_API_KEY']}&url=#{URI.encode(url)}"
            r = RHandler.new
            puts url_scraper_api
            r.source('translate.R', Rails.env.production? ? url_scraper_api : URI.encode(url) )
            text = Translation::Message.generate(r, chat_config, message_text)
        end

        return text
    end

end