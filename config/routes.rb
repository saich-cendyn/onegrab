Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      devise_for :users,
                 skip: [:new, :edit],
                 controllers: {
                     sessions: 'api/v1/users/sessions',
                     registrations: 'api/v1/users/registrations'
                 },
                 path_names: {
                     sign_in: 'login',
                     sign_out: 'logout',
                     sign_up: 'signup'
                 },
                 defaults: { format: :json }
    end
  end


  devise_for :users
  resources :articles
  root "home#index"
end
