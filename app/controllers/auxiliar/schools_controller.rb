class Auxiliar::SchoolsController < ApplicationController


  def show
    school_id = params[:id]
    range = params[:range].to_i
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
    event_schools = EventSchoolRelationship
                      .where(school_id: school_id,
                              created_at: date_range).includes(:event)

    event_schools.map { |es| @events << es.event }

    render template: 'auxiliar/schools/show.json.jbuilder'
  end


end
