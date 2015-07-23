class Event < ActiveRecord::Base


  after_create :set_school

  has_one :event_school_relationship

  ALL_CATEGORIES = ['report_card', 'engagement', 'activity_reminder',
                      'new_user', 'individual', 'massive', 'inscriptions']
  ALL_EVENTS = ['delivered', 'open', 'click', 'bounce',
                'dropped', 'spam_report']
  BOUNCE_DROP_EVENTS = ['bounce', 'spam_report']  # event 'dropped' dont
                                                  # give the email
	def self.to_csv
		CSV.generate do |csv|
			csv << column_names
			all.each do |event|
				csv << event.attributes.values_at(*column_names)
			end
		end
	end

  # Find and set the school's whether the id is given
  #
  def set_school
    additional_arguments = JSON.parse(self.additional_arguments)
    if additional_arguments['school_id'].present?
      EventSchoolRelationship.create(event_id: self.id,
                                  school_id: additional_arguments['school_id'])
    end
  end

end
