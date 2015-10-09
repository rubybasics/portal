Rails.application.routes.draw do
  get '/' => 'site#root'
  get '/api/today.:format' => 'api#today'

  namespace :admin do
    get '/' => 'admin#index'
    get '/today/:date' => 'today#show', as: :today

    scope '/today/:date' do
      resources :activities, only: [:new]
    end
  end
end
