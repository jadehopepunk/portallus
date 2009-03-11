class BlogDetail < ActiveRecord::Base
	belongs_to(:section)
	validates_presence_of(:section)

	def record_id
		id
	end

end
