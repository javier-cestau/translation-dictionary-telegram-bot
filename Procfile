web: R -f R/start.R --gui-none --no-save && bundle exec puma -C config/puma.rb
release: rails db:migrate
release: R CMD BATCH R/start.R nohup.out


