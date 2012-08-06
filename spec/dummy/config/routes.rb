Rails.application.routes.draw do
  devise_for :users

  resources :protected

end
