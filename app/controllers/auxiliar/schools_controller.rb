class Auxiliar::SchoolsController < ApplicationController

  require 'permissions'


  def show
    if self.user_has_permissions(Permissions::EDIT)
      school_id = params[:id]
      range = params[:range].to_i
      category = params[:category].to_i
      event_types = params[:event_types].to_i
      all_categories = ['report_card', 'engagement', 'activity_reminder',
                          'new_user', 'individual', 'massive', 'inscriptions']
      all_events = ['delivered', 'open', 'click', 'bounce',
                    'dropped', 'spam_report']
      bounce_drop_events = ['bounce', 'spam_report']  # event 'dropped' dont
                                                      # give the email
      @events = []

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

      date_range = start_date..DateTime.now

      case category
      when 0
        category_name = all_categories
      when 1
        category_name = 'report_card'
      when 2
        category_name = 'engagement'
      when 3
        category_name = 'activity_reminder'
      when 4
        category_name = 'new_user'
      when 5
        category_name = 'individual'
      when 6
        category_name = 'massive'
      when 7
        category_name = 'inscriptions'
      end

      if event_types == 0
        selected_events = all_events
      else
        selected_events = bounce_drop_events
      end

      event_schools = EventSchoolRelationship.includes(:event).joins(:event)
                      .where(school_id: school_id, created_at: date_range,
                        events: {event: selected_events, category: category_name})

      event_schools.map { |es| @events << es.event }

      render template: 'auxiliar/schools/show.json.jbuilder'
    else
      render json: {
        :message => :error,
        :error => "Unauthorized access."
      }, :status => 401
    end
  end


end
