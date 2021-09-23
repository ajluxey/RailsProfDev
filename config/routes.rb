Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users

  concern :rateable do
    member do
      patch  :rate
      patch  :rate_against
      delete :cancel_rating
    end
  end

  resources :questions, except: :edit, concerns: :rateable do
    post :new_comment, on: :member

    resources :answers, only: %i[create update destroy], concerns: :rateable, shallow: true do
      member do
        patch :update_best
        post :new_comment
      end
    end
  end

  resources :rewards, only: :index
end
