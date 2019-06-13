Raven.configure do |config|
    config.environments = %w[production staging]
    config.processors -= [Raven::Processor::PostData]
    config.processors -= [Raven::Processor::Cookies]
    config.excluded_exceptions += [
      'ActionController::UnknownHttpMethod',
      'URI::InvalidURIError',
      'ActionController::UnknownFormat'
    ]
  
    if Rails.env.development?
      # Set the url of your own sentry testing environment
      config.dsn = ENV['SENTRY_DSN_DEV']
      # Add your enviroment if you have in sentry
      config.environments = %w[]
      if Gem.loaded_specs.key? 'better_errors'
        puts 'WARNING: Sentry does not work with better_errors gem'.yellow
      end
   end
  end
  