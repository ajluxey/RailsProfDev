Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users

  resources :questions do
    resources :answers, only: %i[create update destroy], shallow: true do
      member do
        patch  :update_best
        patch  :rate
        patch  :rate_against
        delete :cancel_rating
      end
    end
  end

  resources :rewards, only: :index
end
