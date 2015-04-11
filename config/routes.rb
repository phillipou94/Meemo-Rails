Rails.application.routes.draw do
  namespace :api do
    resources :users , only: [:index,:new,:create,:update,:show]
    post "/login" => "sessions#login"
    get "/logout" => "sessions#logout"
  end 

end
