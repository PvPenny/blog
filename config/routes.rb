Rails.application.routes.draw do
  get 'coment/index'
  get 'coment/update'
  get 'coment/destroy'
  resources :tags
  mount_devise_token_auth_for 'User', at: 'auth'
  resources :posts
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
