require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  namespace :admin do
    authenticate :admin_user do
      mount Sidekiq::Web => '/sidekiq'
    end
  end
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  telegram_webhook TelegramController

  get '/status', to: 'status#index'

  post '/telegram/webhook/succeeded', to: 'telegram_webhook#succeeded'

end
