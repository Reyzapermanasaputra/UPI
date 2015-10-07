Rails.application.routes.draw do
  patch "/users/:id", :to => 'users#add_room'
  resources :classrooms
  root to: 'static_pages#home'
  get "mailbox/inbox" => "mailbox#inbox", as: :mailbox_inbox
  get "mailbox/sent" => "mailbox#sent", as: :mailbox_sent
  get "mailbox/trash" => "mailbox#trash", as: :mailbox_trash
  resources :conversations do
    member do
      post :reply
      post :trash
      post :untrash
    end
  end
  devise_for :users
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  scope "/admin" do
    resources :users do
      resources :topics
      member do
        get :following, :followers
      end
    end
  end
  resources :roles

  mount Ckeditor::Engine => '/ckeditor'
     resources :topics do
         resources :assigments do
           resources :collection_assigments
         end
         resources :units
         resources :evaluations do
           collection do
  	     get '/chart', to: 'evaluations#chart', as: :chart_evaluations
	   end
           resources :quizzes do
             collection do
  	       get '/report', to: 'quizzes#report', as: :report_quizzes
	     end
             resources :scores
           end
          collection do
           post "/:id", :to => 'scores#create', as: :create_scores
	   get "/:id/quizzes/index", :to => 'quizzes#index', as: :index_quizzes
           post "/quizzes/start", :to => 'quizzes#start'
           get "/:id/quizzez/question", :to => 'quizzes#question', as: :question_quizzes
 	   post "/:id/quizzes/question", :to => 'quizzes#question'
	   post "/:id/quizzes/answer", :to => 'quizzes#answer', as: :answer_quizzes
	   get "/:id/quizzes/end", :to => 'quizzes#end'
         end
         end
end
  resources :assigments do
    resources :collection_assigments
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
