class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	# protect_from_forgery with: :null_session

	def user_has_permissions(permission_level_needed, &block)
		token = request.headers["X-Auth-Token"]
		if !token and params[:token] then
			token = params[:token]
		end
		permitted = true
		if User.where(token: token).present? then
			user = User.where(token: token).first
			permitted = (user.permissions & permission_level_needed) == permission_level_needed
		else
			permitted = false
		end

		if block then
			if permitted then
				block.call
			else
				render json: {
					:message => :error,
					:error => "Unauthorized access."
				}, :status => 401
			end
		else
			return permitted
		end
	end

	def user_from_token
		token = request.headers["X-Auth-Token"]
		User.where(token: token).first
	end

	def set_relationship_params(range, category, event_types)
		case range
		when 0
		  start_date = 1.week.ago.midnight
		when 1
		  start_date = 1.day.ago.midnight
		when 2
		  start_date = 1.month.ago.midnight
		when 3
		  start_date = 3.months.ago.midnight
		end

		@date_range = start_date..DateTime.now

		case category
		when 0
		  @category_name = Event::ALL_CATEGORIES
		when 1
		  @category_name = 'report_card'
		when 2
		  @category_name = 'engagement'
		when 3
		  @category_name = 'activity_reminder'
		when 4
		  @category_name = 'new_user'
		when 5
		  @category_name = 'individual'
		when 6
		  @category_name = 'massive'
		when 7
		  @category_name = 'inscriptions'
		end

		if event_types == 0
		  @selected_events = Event::ALL_EVENTS
		else
		  @selected_events = Event::BOUNCE_DROP_EVENTS
		end
	end

end
