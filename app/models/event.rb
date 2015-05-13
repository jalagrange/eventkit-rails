class Event < ActiveRecord::Base


  after_create :set_school

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
