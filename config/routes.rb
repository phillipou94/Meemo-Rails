Rails.application.routes.draw do
  namespace :api do

    resources :users , only: [:index,:new,:create,:update,:show]
    post "/login/fb" => "users#facebook_login"
    
    post "/login" => "sessions#login"
    get "/logout" => "sessions#logout"
    get "/current_user" => "api#current_user"

    resources :groups, only: [:create,:show]
    get "/groups/:id/users" => "groups#show_users"
    get "/groups/:id/posts" => "groups#get_posts"
    post "/groups/invite" => "groups#invite_user"
    post "/groups/leave" => "groups#leave_group"
    post "/groups/check" => "groups#get_group_from_people"
    post "/upload_file" => "file_uploader#upload"
    get "/groups" => "groups#get_groups"
    get "/phone" => "groups#get_groups_with_phone"

    resources :posts, only: [:create,:destroy]
    get "/posts/query" => "posts#search"
    get "/posts" => "users#get_posts"

    post "/phone_invite" => "invites#invite"


  end 

end
