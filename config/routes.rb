Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users

  resources :questions do
    resources :answers, only: %i[create update destroy], shallow: true do
      patch :update_best, on: :member
    end
  end

  resources :rewards, only: :index
end
