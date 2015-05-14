class Auxiliar::SchoolsController < ApplicationController


  def show
    school_id = params[:id]
    range = params[:range].to_i
    category = params[:category].to_i
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

    case category
    when 0
      category_name = nil
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

    events = ['delivered', 'open', 'click', 'bounce', 'drop', 'spam_report']

    date_range = start_date..DateTime.now
    event_schools = EventSchoolRelationship
                      .where(school_id: school_id,
                        created_at: date_range).includes(:event)

    if category_name.nil?
      event_schools.map { |es|
        @events << es.event if events.include?(es.event.event)}
    else
      event_schools.each do |event_school|
        event = event_school.event
        if event.category == category_name && events.include?(event.event)
          @events << event
        end
      end
    end

    render template: 'auxiliar/schools/show.json.jbuilder'
  end


end
