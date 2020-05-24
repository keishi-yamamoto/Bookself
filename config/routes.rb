Rails.application.routes.draw do
  root 'users/users#top'

  devise_for :users,
    path: '',
    path_names: {
      sign_up: '',
      sign_in: 'login',
      sign_out: 'logout',
      registration: "signup",
  },
    controllers: {
      registrations: "users/devise/registrations",
      sessions: "users/devise/sessions"
  }

  scope module: :users do
    get 'users/search_id'
    resources :users
  end


  devise_for :admins, controllers: {
    sessions: "admins/devise/sessions",
    passwords: "adminss/devise/passwords",
    registrations: "admins/devise/registrations"
  }
end
