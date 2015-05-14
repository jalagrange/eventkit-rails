if @events
  json.array! @events do |event|
    json.partial! 'auxiliar/schools/show',
      event: event
  end
end
