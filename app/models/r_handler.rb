class RHandler
    def initialize()
      @r = Rails.env.production? ? ::RinRuby.new({echo: false})
                                 : ::Rserve::Simpler.new
    end
    def source(file, word, language_source, language_translation)
        url_to_scrap = "https://www.wordreference.com/#{language_source}#{language_translation}/#{word}"

                
        url = 'http://api.scraperapi.com'
        query = {
            'api_key' => 'c937f10047ebff964b3638fd79c39bf5',
            'url' => url_to_scrap
        }

        response = HTTParty.get(url, query: query)
        page_html = response.body
        puts 'creating file'
        File.open("#{Rails.root}/public/word.html", 'w') {|f| f.write(page_html) }
        
        puts 'executing R'
        eval_command = <<-EOF
                        source('#{Rails.root}/R/#{file}')
                        translate('#{Rails.root}/public/word.html')
                    EOF
                    
        Rails.env.production? ? @r.eval(eval_command)
                              : @r.command(eval_command)
    end

    def get_var(variable)
        results = Rails.env.production? ? @r.pull(variable)
                                        : @r.converse(variable)

        results.class == Array ? results.map { |string| CGI.unescape(string) }
                               : CGI.unescape(results)
    end

    def quit
        if !Rails.env.production?
            @r.quit()
        end
    end
end
