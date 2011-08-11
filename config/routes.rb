FT2011::Application.routes.draw do

  # Authentication routes
  match 'user/edit' => 'users#edit', :as => :edit_current_user
  match 'signup' => 'users#new', :as => :signup
  match 'logout' => 'sessions#destroy', :as => :logout
  match 'login' => 'sessions#new', :as => :login
  resources :sessions
  resources :users

  # Generated routes
  resources :attendances
  resources :snapshots
  resources :registrations
  resources :question_options
  resources :questions
  resources :responses
  resources :organization_types
  resources :organization_users
  resources :organizations
  resources :measurements
  resources :measurement_categories
  resources :locations
  resources :id_cards
  resources :events
  resources :event_types
  resources :contacts
  resources :checkpoints
  resources :announcements
  
  
  # Checkpoint routes
  match 'checkpoints/distribute/:id' => 'checkpoints#distribute', :as => :distribute
  match 'checkpoints/take/:id' => 'checkpoints#take_checkpoint', :as => :take_checkpoint
  match 'checkpoints/result/:id' => 'checkpoints#results', :as => :checkpoint_results
  match 'checkpoints/all' => 'checkpoints#all', :as => :all_checkpoints
  match 'checkpoints/organizations' => 'checkpoints#organizations', :as => :organizations_checkpoints
  match 'checkpoints/organization_analysis/:id' => 'checkpoints#organization_analysis', :as => :organization_analysis
  match 'organizations/all' => 'organizations#all', :as => :all_organizations
  match 'measurements/results/:id' => 'measurements#results', :as => :measurement_results
  match 'events/measurements' => 'events#measurements', :as => :events_measurements
  match 'events/all' => 'events#all', :as => :all_events
  match 'events/past' => 'events#past', :as => :past_events
  # match 'users/show/:id' => 'users#show', :as => :users_show
  # match 'users/edit' => 'users#edit', :as => :users_edit
  match 'users/promote/:id' => 'users#promote', :as => :promote
  match 'users/reseter/:email' => 'users#reseter', :as => :reseter
  match 'users/reset/' => 'users#reset', :as => :reset
  match 'users/new_admin' => 'users#new_admin', :as => :new_admin
  match 'users/all' => 'users#all', :as => :all_users
  #map.edit '/users/finalize/:id', :controller=> 'users', :action => 'finalize'


  # Semi-static routes
  match 'home' => 'home#home', :as => :home
  match 'about' => 'home#about', :as => :about
  match 'faq' => 'home#faq', :as => :faq
  match 'privacy' => 'home#privacy', :as => :privacy
  match 'contact' => 'home#contact', :as => :contact
  
  # Default route
  root :to => 'home#home'

end
