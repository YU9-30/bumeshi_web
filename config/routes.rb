Rails.application.routes.draw do
  get 'reviews/new', to: 'reviews#new'
  get 'reviews/destroy', to: 'reviews#destory'
  resources :reviews, only: [:new, :create, :destroy]
  #eateriesコントローラ
  
  get 'eateries', to:'eateries#index'#飲食店一覧ページ
  get 'eateries/new', to: 'eateries#new'#飲食店を登録するページ
  get 'eateries/find', to: 'eateries#find'#APIで店舗を検索した結果を表示するページ
  get 'eateries/all', to: 'eateries#all'
  get 'eateries/category', to: 'eateries#category'
  get 'eateries/search', to: 'eateries#search'#bumeshiに登録されているデータを検索する
  post 'eateries', to:'eateries#create'
  get 'eateries/:id', to: 'eateries#show'
  
  resources :eateries, only: [:index, :new, :create, :show]
  
  #usersコントローラ　
  get 'mypage', to: 'users#me'#mypageにアクセスでuserコントローラのmeが呼ばれる
  get 'users/new', to: 'users#new', as:'onbording' #ユーザーの新規作成に必要な情報を入力する 
  get 'users/create', to: 'user#create' #ユーザーを登録する
  resources :users, only: [:new, :create]
  
  #sessionsコントローラ 主にログイン状態の保持のために使用
  delete 'signout', to:'sessions#destroy', as: 'signout'
  get 'auth/google_oauth2/callback', to: 'sessions#new', as: 'signin' #ユーザーデータベースにユーザーが存在するか
  get 'auth/failure', to: redirect('/')
  resources :sessions, only: [:new, :create, :destroy]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'eateries#index' 
  
end
