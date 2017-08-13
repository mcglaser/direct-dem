Rails.application.routes.draw do


  root 'districts#home'
  
  get 'addy' => 'districts#parse_address'

  get 'address' => 'districts#address'

  get 'bills' => 'districts#bills'
  
  resources :districts

end
