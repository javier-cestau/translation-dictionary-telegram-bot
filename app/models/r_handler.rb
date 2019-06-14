class RHandler
    def initialize()
      @r = Rails.env.production? ? ::RinRuby.new({echo: false})
                                 : ::Rserve::Simpler.new
    end
    def source(file, word, language_source, language_translation)
        url = "https://www.wordreference.com/#{language_source}#{language_translation}/#{word}"

        conn = Faraday.new do |connection|
            connection.use FaradayMiddleware::FollowRedirects
            connection.response :encoding  # use Faraday::Encoding middleware
            connection.adapter Faraday.default_adapter # net/http
        end
        puts 'making the request'
        page_html = conn.get(url).body
        
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
