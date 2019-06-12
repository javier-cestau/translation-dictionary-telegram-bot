web: bundle exec puma -C config/puma.rb
release: rails db:migrate
release: rails telegram:bot:set_webhook
