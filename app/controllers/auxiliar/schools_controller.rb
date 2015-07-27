class Auxiliar::SchoolsController < ApplicationController

  require 'permissions'


  def show
    if self.user_has_permissions(Permissions::EDIT)
      school_id = params[:id]
      range = params[:range].to_i
      category = params[:category].to_i
      event_types = params[:event_types].to_i
      graphic = params[:for_graphic].present?
      @events = []

      set_relationship_params(range, category, event_types)

      select_params = "events.event, events.created_at"
      select_params << ", events.email, events.additional_arguments" if !graphic

      @events = Event.select(select_params)
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
