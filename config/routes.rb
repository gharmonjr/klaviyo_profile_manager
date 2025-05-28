Rails.application.routes.draw do
  root "profiles#index"

  resources :profiles, only: %i[index show] do
    collection do
      get :engagement_modal
      patch :update_engagement
      post :refresh
    end
  end
end
