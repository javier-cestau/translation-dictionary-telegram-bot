Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  telegram_webhook TelegramController

  get '/status', to: 'status#index'

  post '/telegram/webhook/succeeded', to: 'telegram_webhook#succeeded'
end
