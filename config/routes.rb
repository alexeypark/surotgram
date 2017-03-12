Rails.application.routes.draw do
  devise_for :users
  root 'posts#index'
  resources :posts do
    resources :comments
  end

  get 'browse', to: 'posts#browse', as: :browse_posts

  get ':user_name', to: 'profiles#show', as: :profile
  get ':user_name/edit', to: 'profiles#edit', as: :edit_profile
  patch ':user_name/edit', to: 'profiles#update', as: :update_profile

  get ':user_name/following', to: 'profiles#following', as: :following_profile
  get ':user_name/followers', to: 'profiles#followers', as: :followers_profile

  resources :relationships, only: [:create, :destroy]
end
