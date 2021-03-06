require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper

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

    resources :subscriptions, only: %i[create destroy], shallow: true
  end

  resources :rewards, only: :index

  namespace :api do
    namespace :v1 do
      resource :profiles, only: [] do
        get :me
        get :other_users
      end

      resources :questions, except: %i[new edit] do
        resources :answers, except: %i[new edit], shallow: true
      end
    end
  end
end
