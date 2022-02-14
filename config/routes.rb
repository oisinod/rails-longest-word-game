Rails.application.routes.draw do
  get 'game', to: 'games#game'
  get 'result', to: 'games#result'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
