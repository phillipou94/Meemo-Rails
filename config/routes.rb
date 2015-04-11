Rails.application.routes.draw do
  namespace :api do
    resources :users , only: [:index,:new,:create,:update,:show]
    post "/login" => "sessions#login"
    get "/logout" => "sessions#logout"
    get "/current_user" => "api#current_user"
    resources :groups, only: [:create,:show]
    get "/groups/:id/users" => "groups#show_users"
    post "/groups/invite" => "groups#invite_user"
    post "/groups/leave" => "groups#leave_group"
  end 

end
