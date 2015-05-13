if @event
  json.event do
    json.partial! 'auxiliar/schools/show',
      event: @event
  end
end
