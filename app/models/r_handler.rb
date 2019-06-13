class RHandler
    def initialize()
      @r = Rails.env.production? ? ::RinRuby.new({echo: false})
                                 : ::Rserve::Simpler.new
    end
    def source(file, word, language_source, language_translation)
        url = "https://www.wordreference.com/#{language_source}#{language_translation}/#{word}"
        eval_command = <<-EOF
                        source('#{Rails.root}/R/#{file}')
                        translate('#{url}')
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
