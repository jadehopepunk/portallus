class BlogEntry < ActiveRecord::Base
	belongs_to(:section)
	validates_presence_of(:section, :heading, :text)

	def record_id
		id
	end

	def has_more_text
		more_text != nil && more_text != ''
	end
end
