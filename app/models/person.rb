
class Person < Site
	validates_presence_of(:unique_name, :first_name, :last_name)
	validates_length_of(:unique_name, :maximum => 50)
	validates_format_of(:unique_name, :with => /^[a-z]*\d*$/)
	validates_uniqueness_of(:unique_name)

	def name
	  (first_name.to_s + ' ' + last_name.to_s).strip
	end

end
