HtdRemote::Application.routes.draw do
  root :to => "remotes#show"

  resource :remote, :only => [:show]

  namespace :htdnet do
    resource :keypad, :only => [:show]
    resources :zones, :only => [:show] do
      member do
        post :set_volume
        post :enable
        post :disable
        post :mute
        post :unmute
        post :set_source
      end
    end
    resources :sources, :only => [:index, :show, :update]
  end
  
end
