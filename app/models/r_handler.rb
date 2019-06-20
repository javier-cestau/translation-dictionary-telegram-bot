class RHandler
    def initialize()
      @r = Rails.env.production? ? ::RinRuby.new({echo: false})
                                 : ::Rserve::Simpler.new
    end

    def source(file, html, word)
        format_word = I18n.transliterate(word.parameterize)
        
        File.open("#{Rails.root}/public/translations/#{format_word}.html", 'w') {|f| f.write(html) }
     
        eval_command = <<-EOF
                        source('#{Rails.root}/R/#{file}')
                        translate('#{Rails.root}/public/translations/#{format_word}.html')
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
