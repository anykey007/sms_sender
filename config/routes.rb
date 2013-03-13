TwentyTwoClientMessages::Application.routes.draw do

  resources :groups do
    resources :clients    
  end

  match "settings"=>"settings#index"
  match "settings/sync"=>"settings#sync"


  resources :messages


  resources :clients do
    resources :messages#, :controller => "clients_messages"
  end
  
  scope ":type", :type => /(wc|rc)/ do
    resources :clients do     
      member do
        post 'send_message'        
      end  
      get '/new_message' => 'clients#new_message'
    end
    resources :messages
  end

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  get '/balance' => "home#balance"
  devise_for :users
  resources :users

end
