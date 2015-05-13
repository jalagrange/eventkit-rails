class Auxiliar::SchoolsController < ApplicationController


  def show
    @event = Event.last

    render template: 'auxiliar/schools/show.json.jbuilder'
  end


end
