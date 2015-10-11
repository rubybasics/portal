Rails.application.routes.draw do
  get '/' => 'site#root', as: :root
  get '/api/today.:format' => 'api#today'

  namespace :admin do
    get '/' => 'admin#index'
    get '/today/:date' => 'today#show', as: :today

    scope '/today/:date' do
      resources :activities, only: [:index, :new, :create]
    end
  end

  # development only
  get '/development/admin'    => 'development#admin'
  get '/development/env'      => 'development#show_env'
  get '/development/session'  => 'development#show_session'
  get '/development/me'       => 'development#show_user'
  get '/development/reset'    => 'development#reset'
  get '/development/pry'      => 'development#pry'
end
