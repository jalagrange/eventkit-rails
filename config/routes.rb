EventKit::Application.routes.draw do
	root :to => 'assets#index'
	get "assets/index"
	post "/" => 'receiver#handle_post'

	namespace :api do
		namespace :v1 do
			# Events
			resources :events

			# Settings
			resources :settings

			# Users
			resources :users
		end
	end

	namespace(:auxiliar, defaults: {format: :json}) do

		resources :schools, only: [:show] do
			get :generate_stats, on: :member
		end

	end
end
