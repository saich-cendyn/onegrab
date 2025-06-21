Rails.application.routes.draw do
  resources :students
  namespace :api do
    namespace :v1 do
      devise_for :users,
                 skip: [:new, :edit],
                 controllers: {
                     sessions: 'api/v1/users/sessions',
                     registrations: 'api/v1/users/registrations',
                     confirmations: 'api/v1/users/confirmations'
                 },
                 path_names: {
                     sign_in: 'login',
                     sign_out: 'logout',
                     sign_up: 'signup'
                 },
                 defaults: { format: :json }
    end
  end

  devise_for :members
  resources :articles
  resources :courses

  root "home#index"
end
