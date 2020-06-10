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
    get 'search/search_api', as: 'rakuten-api'
    get 'search/index', as: 'result'
    get 'search/book_title',  as: 'search-title'
    get 'search/new_title', as: 'register-title', to: 'search#new'
    resources :user_titles, except: [:edit]
    resources :titles, only: [:index, :update]
    get 'book_shelves/nil', as: 'book_shelf_nil'
    delete 'book_shelves/destroy_all', as: 'book_shelves_destroy'
    resources :book_shelves, except: [:new, :edit]
    get 'users/search_id'
    get 'users/search_mail'
    get 'users/search'
    resources :users, except: [:index, :create, :new]
  end

  devise_for :admins, controllers: {
    sessions: "admins/devise/sessions",
    passwords: "adminss/devise/passwords",
    registrations: "admins/devise/registrations"
  }
end
