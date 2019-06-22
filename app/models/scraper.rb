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
            url_scraper_api = "http://api.scraperapi.com?api_key=#{ENV['SCARPER_API_KEY']}&url=#{URI.encode(url)}"
            r = RHandler.new
            r.source('wordreference_scraper.R', Rails.env.production? ? url_scraper_api : URI.encode(url) ) # Avoid spend monthly requests on scaperAPI service on development
            text = Translation::Message.generate(r, chat_config, message_text)
        end

        return text
    end

end