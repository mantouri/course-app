# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  root 'courses#index'
  resources :courses
  mount ApiRoot => ApiRoot::PREFIX 
  mount GrapeSwaggerRails::Engine => '/apidoc'
  # 這樣做的好處是把 api prefix 也都放在 api_root.rb 進行管理， route 那邊就只要寫一次就行。
  # 我們將 api 掛載在路由網址 /api 下，這樣所有的 api 都是從 /api 開始
end
