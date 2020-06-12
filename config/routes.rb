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
    get 'about', to: 'users#about', as: 'about'
    # 商品検索に関わるアクション
    get 'search/search_api', as: 'rakuten_api'
    get 'search/index', as: 'result'
    get 'search/book_title'
    get 'search/total', as: 'search_total'
    get 'search/results', as: 'search_results'
    get 'user_titles/other/:user_id', to: 'user_titles#index_other', as: 'user_titles_other'
    patch 'user_titles/update_all', as: 'update_all_titles'
    resources :user_titles, except: [:edit]
    get 'titles', to: 'titles#index', as: 'titles'
    get 'book_shelves/nil', as: 'book_shelf_nil'
    delete 'book_shelves/destroy_all', as: 'book_shelves_destroy'
    get 'book_shelves/other/:user_id', to: 'book_shelves#index_other', as: 'book_shelves_other'
    get 'book_shelf/other/:id', to: 'book_shelves#show_other', as: 'book_shelf_other'
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
