Fuoasis::Application.routes.draw do

  get '/messages/:id', to: 'messages#show'
  get "/calendar/getjson", to: 'calendar#getjson'

  get 'push', to: 'application#push'
  get 'messages', to: 'application#messages'
  get 'calendar', to: 'application#calendar'
  get 'home', to: 'application#home'
  get 'cr', to: 'application#cr'
  get 'ar', to: 'application#ar'
  get 'payments', to: 'application#payments'
  get 'status', to: 'application#status'

  get 'about', to: 'application#about'
  get 'login', to: 'application#login'
  get 'logout', to: 'application#logout'
  post 'tos', to: 'application#tos'
  get 'auth', to: 'application#auth'
  root to: 'application#home'
  get '*path', to: 'application#home'
end
