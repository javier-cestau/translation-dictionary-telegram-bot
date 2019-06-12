class RHandler
    def initialize()
      @r = Rails.env.production? ? ::RinRuby.new({echo: false})
                                 : ::Rserve::Simpler.new
    end
    def source
        Rails.env.production? ? @r.eval("source('#{Rails.root}/R/script.R')")
                              : @r.command("source('#{Rails.root}/R/script.R')")
    end

    def get_var(variable)
        Rails.env.production? ? @r.pull(variable)
                              : @r.converse(variable)
    end

    def quit
        if !Rails.env.production?
            @r.quit()
        end
    end
end
