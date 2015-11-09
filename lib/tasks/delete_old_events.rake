desc 'Destroy 3 month old events and its school relationship'
task delete_old_events: :environment do

  ActiveRecord::Base.transaction do
    Event.where(["created_at < ?", 3.month.ago]).delete_all
    EventSchoolRelationship.where(["created_at < ?", 3.month.ago]).delete_all
  end
end
