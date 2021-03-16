# frozen_string_literal: true
Rails.application.routes.draw do
  resources :repositories, param: :name
  resources :topics
  resources :security
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
