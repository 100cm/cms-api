Rails.application.routes.draw do


  namespace :api do
    resources :users do
      collection do
        post :sign_in
      end
    end
  end

  namespace :api do
    resources :banners
  end

  namespace :api do
    resources :system_configs
  end

  namespace :api do
    resources :attachments do
      collection do
        post :ckeditor
      end
    end
  end

  namespace :api do
    resources :contents
  end

  namespace :api do
    resources :menus do
      collection do
        get :all
      end
    end
  end

  namespace :api do
    resources :templates
  end

  namespace :api do
    resources :news
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
