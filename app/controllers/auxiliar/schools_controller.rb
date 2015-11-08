class Auxiliar::SchoolsController < ApplicationController

  require 'permissions'

  before_action :require_permission

  def show
    school_id = params[:id]
    range = params[:range].to_i
    category = params[:category].to_i
    event_types = params[:event_types].to_i
    @events = []

    set_relationship_params(range, category, event_types)

    select_params = "events.event, events.created_at, events.email, \
                      events.additional_arguments"

    @events = Event.select(select_params)
              .joins(:event_school_relationship)
                .where(event: @selected_events, category: @category_name,
                        created_at: @date_range,
                        event_school_relationships: {school_id: school_id})

    render json: Oj.dump(@events, mode: :compat)
  end


  def generate_stats
    school_id = params[:id]
    range = params[:range].to_i
    category = params[:category].to_i
    event_types = params[:event_types].to_i
    events = []
    @total = {delivered: [], open: [], click: [], bounce: []}

    set_relationship_params(range, category, event_types)

    select_params = "events.event, events.created_at"

    events = Event.select(select_params)
              .joins(:event_school_relationship)
                .where(event: @selected_events, category: @category_name,
                        created_at: @date_range,
                        event_school_relationships: {school_id: school_id})

    events_by_date = events.group_by {|e| [e.created_at.to_date, e.event]}
    events_by_date.each do |date_event, array_events|
      date = date_event.first
      event_name = date_event.last
      case event_name
      when 'delivered'
        @total[:delivered] << [set_utc(date.to_time), array_events.count]
      when 'open'
        @total[:open] << [set_utc(date.to_time), array_events.count]
      when 'click'
        @total[:click] << [set_utc(date.to_time), array_events.count]
      else
        @total[:bounce] << [set_utc(date.to_time), array_events.count]
      end
    end

    render json: Oj.dump(@total, mode: :compat)
  end


  private

    #Checks if the user has the required permissions.
    #
    def require_permission
      unless self.user_has_permissions(Permissions::EDIT)
        render json: {
          :message => :error,
          :error => "Unauthorized access."
        }, :status => 401
      end
    end

    def set_utc(date)
      date.to_f * 1000
    end
end