class Auxiliar::SchoolsController < ApplicationController

  require 'permissions'


  def show
    if self.user_has_permissions(Permissions::EDIT)
      school_id = params[:id]
      range = params[:range].to_i
      category = params[:category].to_i
      event_types = params[:event_types].to_i
      @events = []

      set_relationship_params(range, category, event_types)

      # events = EventSchoolRelationship.includes(:event).joins(:event)
      #                 .where(school_id: school_id, created_at: @date_range,
      #                   events: {event: @selected_events, category: @category_name})

      @events = Event.select("events.event, events.created_at")
                .joins(:event_school_relationship)
                  .where(event: @selected_events, category: @category_name,
                          created_at: @date_range,
                            event_school_relationships: {school_id: school_id})

      render json: Oj.dump(@events, mode: :compat)
      # render template: 'auxiliar/schools/show.json.jbuilder'
      # render json: @events
    else
      render json: {
        :message => :error,
        :error => "Unauthorized access."
      }, :status => 401
    end
  end


end
