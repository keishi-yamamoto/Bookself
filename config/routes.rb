Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "users/devise/sessions",
    passwords: "users/devise/passwords",
    registrations: "users/devise/registrations"
  }
  devise_for :admins, controllers: {
    sessions: "admins/devise/sessions",
    passwords: "adminss/devise/passwords",
    registrations: "admins/devise/registrations"
  }
end
